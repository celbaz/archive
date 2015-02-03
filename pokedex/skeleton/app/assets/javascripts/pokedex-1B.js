Pokedex.RootView.prototype.renderPokemonDetail = function (pokemon) {
  this.$pokeDetail.empty();
  var attr = _.clone(pokemon.attributes);
  var $ul = $("<ul class='detail'><ul>");

  var $li = $("<li>");
  var $img = $("<img>");
  $img.attr("src", pokemon.escape("image_url"));
  $li.append($img).appendTo($ul);

  _.each(attr, function (val, name) { //td said to make dts
    var $li = $("<li>");
    if (name !== "image_url") {
      $li.text(name + " :: " + val);
      $ul.append($li);
    }
  });

  var $toys = $("<ul>").addClass("toys").text("Toys");
  
  this.$pokeDetail.append($ul.append($toys));

  pokemon.toys().each(function (toy) {
    this.addToyToList(toy)
  }.bind(this));

};

Pokedex.RootView.prototype.selectPokemonFromList = function (event) {
  var pokeId = $(event.currentTarget).data("id");
  var pokemon = new Pokedex.Models.Pokemon({ id: pokeId });
  pokemon.fetch({
    success: function () {
      Pokedex.rootView.renderPokemonDetail(pokemon);
    }
  });
};
