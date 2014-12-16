(function () {
  if (typeof Asteroids === "undefined") {
      window.Asteroids = {};
  }

  var MO = Asteroids.MovingObject = function (args) {
    this.pos = args.pos;
    this.vel = args.vel;
    this.radius = args.radius;
    this.color = args.color;
    this.game = args.game;
  };

  MO.prototype.draw = function (ctx) {
    ctx.fillStyle = this.color;
    ctx.beginPath();
    ctx.arc(this.pos[0],
       this.pos[1],
       this.radius,
       0,
       Math.PI*2,
       false);
    ctx.closePath();
    ctx.fill();
  };


  MO.prototype.move = function () {
    this.pos[0] += this.vel[0];
    this.pos[1] += this.vel[1];
    this.pos = this.game.wrap(this.pos);
  };

  MO.prototype.isCollidedWith = function (otherObject) {
    var distance = Math.sqrt(Math.pow((this.pos[0] - otherObject.pos[0]), 2) +
                    Math.pow((this.pos[1] - otherObject.pos[1]), 2));
    if (distance < (this.radius + otherObject.radius)) {
      return true;
    } else {
      return false;
    }
  };

  MO.prototype.collideWith = function (otherObject) {
    this.game.remove(otherObject);
    this.game.remove(this);
  }

})();
