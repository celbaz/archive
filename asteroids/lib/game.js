(function () {
  if (typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var Game = Asteroids.Game = function () {
    this.asteroids = [];
    this.bullets = [];
    this.addAsteroids();
    this.ship = new Asteroids.Ship([Game.DIM_X/2,Game.DIM_Y/2], this);
  };

  Game.prototype.addAsteroids = function () {
    for (var i = 0; i < Game.NUM_ASTEROIDS; i++) {
      this.asteroids.push(new Asteroids.Asteroid(Game.randomPosition(), this));
    }
  };

  Game.randomPosition = function () {
    return [Game.DIM_X * Math.random(), Game.DIM_Y * Math.random()];
  };

  Game.prototype.draw = function (ctx) {
    ctx.clearRect(0, 0, Game.DIM_X, Game.DIM_Y);
    for (var i = 0; i < this.allObjects().length; i++) {
      this.allObjects()[i].draw(ctx);
    }
  };

  Game.prototype.allObjects = function () {
    return this.asteroids.concat(this.ship).concat(this.bullets);
  };

  Game.prototype.moveObjects = function () {
    this.allObjects().forEach(function (object) {
      object.move();
    });
  };

  Game.prototype.wrap = function (pos) {
    var newPos = pos;
    if (pos[0] > Game.DIM_X) {
      pos[0] = pos[0] - Game.DIM_X;
    } else if (pos[0] < 0) {
      pos[0] = Game.DIM_X;
    }
    if (pos[1] > Game.DIM_Y) {
      pos[1] = pos[1] - Game.DIM_Y;
    } else if (pos[1] < 0) {
      pos[1] = Game.DIM_Y;
    }

    return newPos;
  };

  Game.prototype.checkCollisions = function () {
    var game = this;
    game.allObjects().forEach(function (object1) {
      game.allObjects().forEach(function (object2) {
        if (object1 === object2) {
        } else if (object1.isCollidedWith(object2)) {
          object1.collideWith(object2);
        }
      })
    })
  };

  Game.prototype.step = function () {
    this.moveObjects();
    this.checkCollisions();
  }

  Game.prototype.remove = function (object) {
    if (object instanceof Asteroids.Asteroid) {
      for (var i = 0; i < this.asteroids.length; i++) {
        if (this.asteroids[i] === object) {
          this.asteroids.splice(i, 1);
        }
      }
    } else if (object instanceof Asteroids.Bullet) {
      for (var i = 0; i < this.bullets.length; i++) {
        if (this.bullets[i] === object) {
          this.bullets.splice(i, 1);
        }
      }
    }
  }

  Game.prototype.addBullet = function (object) {
    if (object instanceof Asteroids.Asteroid) {
      this.asteroids.push(object);
    } else if (object instanceof Asteroids.Bullet) {
      this.bullets.push(object);
    }
  }

  Game.NUM_ASTEROIDS = 20;

  Game.prototype.relocateShip = function () {
    this.ship.pos = [Game.DIM_X/2,Game.DIM_Y/2];
    this.ship.vel = [0, 0];
  }

  Game.prototype.isOutOfBounds = function (pos) {
    if (pos[0] < 0 || pos[0] > Game.DIM_X || pos[1] < 0 || pos[1] > Game.DIM_Y) {
      return true;
    }

    return false;
  }



})();
