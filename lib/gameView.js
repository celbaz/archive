(function(){
  if (typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var View = Asteroids.GameView = function (game, ctx) {
    this.game = game;
    this.ctx = ctx;
  };

  View.prototype.start = function(){
    var view = this;
    window.setInterval(function(){
      view.game.step();
      view.game.draw(view.ctx);
    }, 20);
  };


})();
