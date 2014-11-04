// Comments:
// * Pass in an el. OK
// * I removed comparator.
// * Fix weird rendering bug.
// * Definitely add the form. 
// * Each pokemon has many of Xs. When clicking detail view, show all
//   the Xs. Allow them to click for a detail view of the x.
//     * I think this needs: (1) association method, (2) association collection, (3) parse method.
// * **Maybe as a bonus build some wizard for saving nested collection.**

window.Pokedex = function ($el) {
  this.$el = $el;
  this.pokes = new Pokedex.Collections.Pokemon;
	this.$pokeList = this.$el.find('.pokemon-list');
	this.$pokeDetail = this.$el.find('.pokemon-detail');
  this.$newPoke = this.$el.find('.new-pokemon');

	this.$pokeList.on('click', 'li', this.selectPokemonFromList.bind(this));
  this.$newPoke.on('submit', this.submitPokemonForm.bind(this)); 
}

Pokedex.Models = {};
Pokedex.Collections = {};

// create Pokemon Backbone model
Pokedex.Models.Pokemon = Backbone.Model.extend({
	urlRoot: '/pokemon'
});

// create Pokemon Backbone collection
Pokedex.Collections.Pokemon = Backbone.Collection.extend({
  model: Pokedex.Models.Pokemon,
	url: '/pokemon',
  comparator: 'number'
});

Pokedex.prototype.listPokemon = function (callback) {
	// create collection
	// fetch collection
	// print names asynch
  this.pokes.fetch({
  	success: (function () {
  		this.pokes.each(this.renderListItem.bind(this));
      callback && callback();
  	}).bind(this)
  });
  return this.pokes;
};

Pokedex.prototype.renderListItem = function (pokemon) {
	// build LI
	// apped it to $pokeList
	var $li = $('<li class="poke-list-item" data-id=' +
				pokemon.get('id') + '>');
	var shortInfo = ['name', 'number', 'poke_type'];
	shortInfo.forEach(function (attr) {
		$li.append(attr + ': ' + pokemon.get(attr) + '<br>');
	});

	this.$pokeList.append($li);
};

Pokedex.prototype.createPokemon = function (attrs, callback) {
	// instantiate object
	// set attributes
	// save and call callback
	var poke = new Pokedex.Models.Pokemon(attrs);

  // Have an alert pop-up which confirms saving when that is complete.
  // Don't add the new pokemon until it is saved properly.
	var that = this;
  poke.save(attrs, {
    success: function() {
      that.pokes.add(poke)
      callback && callback.call(this, poke);
    }
  });

  return poke;
};

Pokedex.prototype.renderDetail = function (pokemon) {
	var num = pokemon.get('number');
  
  // num can be string or number depending on whether it came
  // from the server or not #=> convert to str if it's a number
  if(typeof num === 'number') {
    num = "" + num;
  }
	while(num.length < 3) {
    num = '0' + num;
	}
	var string = '<img src="assets/pokemon_snaps/' + num + '.png"' +
				'style="float:left;"><br>';
	for(var attr in pokemon.attributes) {
		if(pokemon.get(attr) && attr !== 'id') {
			string += '<span style="font-weight:bold;">' + attr + ':</span> ' +
						pokemon.get(attr) + '<br>';
		}
	}

	this.$pokeDetail.html(string);
};

Pokedex.prototype.submitPokemonForm = function(event) {
  event.preventDefault();
  var pokeAttrs = $(event.target).serializeJSON()['pokemon'];

  var that = this;
  this.createPokemon(pokeAttrs, function(pokemon) {
    that.renderDetail(pokemon);
    that.renderListItem(pokemon);
  });
};

Pokedex.prototype.selectPokemonFromList = function (event) {
  var $target = $(event.target);

	var pokeId = $target.data('id');
	var pokemon = this.pokes.get(pokeId);

	this.renderDetail(pokemon);
};

$(function() {
  var $rootEl = $('#pokedex');

	var pokedex = new Pokedex($rootEl);
  pokedex.listPokemon();
});
