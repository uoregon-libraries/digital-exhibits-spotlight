$(document).ready(function(){
  $(".exhibit-card").each(function(){
    link = $(this).find("a").first();
    var $this = $(this);
    link.focus(function(){
      $this.toggleClass("hover");
    });
    link.blur(function(){
      $this.toggleClass("hover");
    });
  });
});
