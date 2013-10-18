
var NS = (function(){
// 名前空間をクロージャ内に保持する
 var namespaces = {};

 /**
  * 名前空間関数
  * @param  string 名前空間名
  * @return object 名前空間
  */
  return function(name) {
    // すでに存在すれば返す、存在しなければ初期化して返す
    return (namespaces[name]) ? namespaces[name] : namespaces[name] = {};
  };
})();

(function() {
  // 名前空間を作成
  var GALLERIES = NS("GALLERIES");
  //GALLERIES.gallery[0] = $('.ad-gallery').adGallery();
})();
