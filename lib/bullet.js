(function () {
  if (typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var Bullet = Asteroids.Bullet = function (pos, vel, game) {
    var args = {color: Bullet.COLOR,
      radius: Bullet.RADIUS,
      pos: pos,
      vel: vel,
      game: game};
      Asteroids.MovingObject.call(this, args);
    };

    Asteroids.Util.inherits(Bullet, Asteroids.MovingObject);

    Bullet.prototype.collideWith = function (otherObject) {
      if (otherObject instanceof Asteroids.Asteroid) {
        this.game.remove(otherObject);
        this.game.remove(this);
      }
    }

    Bullet.COLOR = "#f1c40f";
    Bullet.RADIUS = 50;

    Bullet.prototype.isWrappable = false;

  })();
