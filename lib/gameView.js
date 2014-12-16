(function(){
  if (typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var View = Asteroids.GameView = function (game, ctx) {
    this.game = game;
    this.ctx = ctx;
    this.ship = this.game.ship;
  };


  View.prototype.bindKeyHandlers = function() {
    var view = this;
    key('w', function () { view.ship.power([0,-5]) } );
    key('s', function () { view.ship.power([0,5]) } );
    key('a', function () { view.ship.power([-5,0]) } );
    key('d', function () { view.ship.power([5,0]) } );
    key('l', function () { view.ship.fireBullet() } );
  };

  View.prototype.start = function(){
    this.bindKeyHandlers();
    var view = this;
    window.setInterval(function(){
      view.game.step();
      view.game.draw(view.ctx);
    }, 20);
  };


})();
