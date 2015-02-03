(function () {
  if (typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var Asteroid = Asteroids.Asteroid = function (pos, game) {
    var args = {color: Asteroid.COLOR,
                radius: Asteroid.RADIUS,
                pos: pos,
                vel: Asteroids.Util.randomVec(15),
                game: game};
    Asteroids.MovingObject.call(this, args);
  };

  Asteroids.Util.inherits(Asteroid, Asteroids.MovingObject);

  Asteroid.prototype.collideWith = function (otherObject) {
    if (otherObject instanceof Asteroids.Ship) {
      this.game.relocateShip();
    }
  }

  Asteroid.COLOR = "#95a5a6";
  Asteroid.RADIUS = 50;

})();
