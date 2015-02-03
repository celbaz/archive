(function () {

  if (typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var Ship = Asteroids.Ship = function (pos, game) {
    (pos);
    var args = {color: Ship.COLOR,
      radius: Ship.RADIUS,
      pos: pos,
      vel: [0, 0],
      game: game};
      Asteroids.MovingObject.call(this, args);
  };

  Asteroids.Util.inherits(Ship, Asteroids.MovingObject);

  Ship.prototype.power = function (impulse) {
    this.vel[0] += impulse[0];
    this.vel[1] += impulse[1];
  }

  Ship.prototype.fireBullet = function () {
    var bulletPos = this.pos.slice();
    if (this.vel[0] === 0 && this.vel[1] === 0) {
      console.log("HEIayew");
      var bulletVel = [0, -10];
    } else {
      var bulletVel = [this.vel[0] * 2, this.vel[1] * 2];
    }
    var bullet = new Asteroids.Bullet(bulletPos, bulletVel, this.game);
    this.game.addBullet(bullet);
  }

  Ship.COLOR = "#8e44ad";
  Ship.RADIUS = 69;
})();
