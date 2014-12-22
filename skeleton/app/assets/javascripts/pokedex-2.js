Pokedex.RootView.prototype.addToyToList = function (toy) {
  var $li = $("<li>").addClass("toy").data("toy-id", toy.get("id"));
  $li.data("pokemon-id", toy.get("pokemon_id"));
  $li.text(toy.escape("name") + " :: " + toy.escape("happiness") + " :: " + toy.escape("price"))
  $(this.$pokeDetail.find("ul.toys")).append($li);
};

Pokedex.RootView.prototype.renderToyDetail = function (toy) {
  this.$toyDetail.empty();
  var attr = _.clone(toy.attributes);
  var $ul = $("<ul class='detail'><ul>");

  var $li = $("<li>");
  var $img = $("<img>");
  $img.attr("src", toy.escape("image_url"));
  $li.append($img).appendTo($ul);

  _.each(attr, function (val, name) { //td said to make dts
    var $li = $("<li>");
    if (name !== "image_url") {
      $li.text(name + " :: " + val);
      $ul.append($li);
    }
  });

  var $select = $("<select class='change-owner'>").data("toy-id", toy.get("id"))
  this.pokes.each(function(poke){
    var $option = $("<option>").val(poke.get("id"));
    $option.text(poke.escape("name"));
    if(toy.get("pokemon_id") === poke.get("id")){
      $option.attr("selected","true");
    }
    $select.append($option);
  });

  this.$toyDetail.append($ul.append($select));
};

Pokedex.RootView.prototype.selectToyFromList = function (event) {
  var selectedPokemonId = $(event.currentTarget).data("pokemon-id");
  var toyId = $(event.currentTarget).data("toy-id");
  var pokey = new Pokedex.Models.Pokemon( { id: selectedPokemonId } );
  pokey.fetch({
    success: function () {
      var toy = pokey.toys().findWhere({ id: toyId });
      Pokedex.rootView.renderToyDetail(toy);
    }
  });
};

// from pokedex-3.js

Pokedex.RootView.prototype.reassignToy = function (event) {
  var $currentTarget = $(event.target);

  var pokemon = this.pokes.get($currentTarget.val());
  var toy = pokemon.toys().get($currentTarget.data("toy-id"));

  toy.set("pokemon_id", $currentTarget.val());
  toy.save({}, {
    success: (function () {
      pokemon.toys().remove(toy);
      this.renderToysList(pokemon.toys());
      this.$toyDetail.empty();
    }).bind(this)
  });
};

Pokedex.RootView.prototype.renderToysList = function (toys) {
  this.$pokeDetail.find(".toys").empty();
  toys.each((function(toy) {
    this.addToyToList(toy);
  }).bind(this));
};
