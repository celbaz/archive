(function () {
  if (typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var Game = Asteroids.Game = function () {
    this.asteroids = [];
    this.addAsteroids();
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
    for (var i = 0; i < this.asteroids.length; i++) {
      this.asteroids[i].draw(ctx);
    }
  };

  Game.prototype.moveObjects = function () {
    this.asteroids.forEach(function (asteroid) {
      asteroid.move();
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
    game.asteroids.forEach(function (asteroid1) {
      game.asteroids.forEach(function (asteroid2) {
        if (asteroid1 === asteroid2) {
        } else if (asteroid1.isCollidedWith(asteroid2)) {
          asteroid1.collideWith(asteroid2);
        }
      })
    })
  };

  Game.prototype.step = function () {
    this.moveObjects();
    this.checkCollisions();
  }

  Game.prototype.remove = function (asteroid) {
    for (var i = 0; i < this.asteroids.length; i++) {
      if (this.asteroids[i] === asteroid) {
        this.asteroids.splice(i, 1);
      }
    }
  }

  Game.NUM_ASTEROIDS = 30;


})();
