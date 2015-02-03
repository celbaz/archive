Pokedex.Views = {}

Pokedex.Views.PokemonIndex = Backbone.View.extend({
  events: {
    "click li": "selectPokemonFromList"
  },

  initialize: function () {
    this.collection = new Pokedex.Collections.Pokemon();
  },

  addPokemonToList: function (pokemon) {
    var liContent = JST["pokemonListItem"]({ pokemon: pokemon });
    this.$el.append(liContent);
  },

  refreshPokemon: function (options) {
    this.collection.fetch({
      success: (function () {
        this.render();
        options.success && options.success();
      }).bind(this)
    });
  },

  render: function () {
    this.$el.empty();
    this.collection.each(this.addPokemonToList.bind(this));
  },

  selectPokemonFromList: function (event) {
    var pokemonId = $(event.currentTarget).data("id");

    Backbone.history.navigate(
      "/pokemon/" + pokemonId,
      { trigger: true }
    );

    /*
    var pokemonDetail =
        new Pokedex.Views.PokemonDetail({ model: pokemon });
    $("#pokedex .pokemon-detail").html(pokemonDetail.$el);
    pokemonDetail.refreshPokemon();
    */
  }
});

Pokedex.Views.PokemonDetail = Backbone.View.extend({
  events: {
    "click .toys li": "selectToyFromList"
  },

  refreshPokemon: function (options) {
    this.model.fetch({
      success: (function () {
        this.render();
        options.success && options.success();
      }).bind(this)
    });
  },

  render: function () {
    this.$el.html(JST["pokemonDetail"]({ pokemon: this.model }));

    var $toys = this.$el.find(".toys");
    this.model.toys().each((function (toy) {
      $toys.append(JST["toyListItem"]({ toy: toy }));
    }).bind(this));
  },

  selectToyFromList: function (event) {
    var toyId = $(event.currentTarget).data("id");

    Backbone.history.navigate(
      "pokemon/" + this.model.id + "/toys/" + toyId,
      { trigger: true }
    );

    /*
    var toy = this.model.toys().get(toyId);
    var toyDetail = new Pokedex.Views.ToyDetail({ model: toy });
    $("#pokedex .toy-detail").html(toyDetail.$el);
    toyDetail.render();
    */
  }
});

Pokedex.Views.ToyDetail = Backbone.View.extend({
  render: function () {
    this.$el.html(JST["toyDetail"]({ toy: this.model, pokes: [] }));
    return this;
  }
});

/*
$(function () {
  var pokemonIndex = new Pokedex.Views.PokemonIndex();
  pokemonIndex.refreshPokemon();
  $("#pokedex .pokemon-list").html(pokemonIndex.$el);
});
*/
