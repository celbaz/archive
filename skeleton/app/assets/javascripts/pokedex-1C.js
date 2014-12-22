Pokedex.RootView.prototype.createPokemon = function (attrs, callback) {
  var pokemon = new Pokedex.Models.Pokemon();
  var view = this;
  pokemon.save(attrs, {
    success: function () {
      view.pokes.add(pokemon);
      view.addPokemonToList(pokemon);
      callback(pokemon);
    }
  });
};

Pokedex.RootView.prototype.submitPokemonForm = function (event) {
  event.preventDefault();
  var attrs = $(event.currentTarget).serializeJSON();
  this.createPokemon(attrs.pokemon, this.renderPokemonDetail.bind(this));
};
