Pokedex.RootView.prototype.addPokemonToList = function (pokemon) {
  var $li = $("<li class='poke-list-item'></li>").data("id", pokemon.escape("id"));
  $li.text(pokemon.escape("name") + " :: " + pokemon.escape("poke_type"));
  this.$pokeList.append($li);
};

Pokedex.RootView.prototype.refreshPokemon = function (callback) {
  var view = this;
  this.pokes.fetch({ success: populate });
  function populate() { view.pokes.each( function (pokemon){
      // console.log(pokemon);
      view.addPokemonToList(pokemon);
    })
  };

};
