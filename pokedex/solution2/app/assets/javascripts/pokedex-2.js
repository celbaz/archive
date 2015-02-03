Pokedex.RootView.prototype.addToyToList = function (toy) {
  var liContent = JST["toyListItem"]({ toy: toy });
  this.$pokeDetail.find(".toys").append(liContent);
};

Pokedex.RootView.prototype.renderToyDetail = function (toy) {
  var detailContent = JST["toyDetail"]({ toy: toy, pokes: this.pokes });
  this.$toyDetail.html(detailContent);
};

Pokedex.RootView.prototype.selectToyFromList = function (event) {
  var $target = $(event.target);

  var toyId = $target.data('id');
  var pokemonId = $target.data('pokemon-id');

  var pokemon = this.pokes.get(pokemonId);
  var toy = pokemon.toys().get(toyId);

  this.renderToyDetail(toy);
};
