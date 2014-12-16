(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }

    var Util = Asteroids.Util = {};

    Util.inherits = function (ChildClass, SuperClass) {
        function Surrogate () {};
        Surrogate.prototype = SuperClass.prototype;
        ChildClass.prototype = new Surrogate();
    };

    Util.randomVec = function (length) {
        var randX = Math.random();
        var randY = Math.random();
        if (Math.random() >= 0.5) {
          randX *= -1;
        }
        if (Math.random() >= 0.5) {
          randY *= -1;
        }
        return [randX * length, randY * length];
    };

})();
