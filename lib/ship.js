(function () {

  if (typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }


  var Ship = Asteroids.Ship = function (pos, game) {
    var args = {color: Ship.COLOR,
      radius: Ship.RADIUS,
      pos: pos,
      vel: 0,
      game: game};
      Asteroids.MovingObject.call(this, args);
    };


  
  Ship.COLOR = "#8e44ad";
  Ship.RADIUS = 69;
})();
