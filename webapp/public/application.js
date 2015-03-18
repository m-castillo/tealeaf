$(document).ready(function() {
  player_hits();
  player_stays();
  play_again();
  dealer_hit();

});

// BLACKJACK AJAX --------- FOR PICK 5, GO TO LINE XXX

function player_hits() {
  $(document).on("click", "form#hit_form input", function() {
    $.ajax({
      type: "POST",
      url: "/game/player/hit"
    }).done(function(msg) {
      $("#game").replaceWith(msg)
    });
    return false;
  });
}

function player_stays() {
  $(document).on("click", "form#stay_form input", function() {
    $.ajax({
      type: "POST",
      url: "/game/player/stay"
    }).done(function(msg) {
      $("#game").replaceWith(msg)
    });
    return false;
  });
}

function dealer_hit() {
  $(document).on("click", "form#dealer_hit input", function() {
    $.ajax({
      type: "POST",
      url: "/game/dealer/hit"
    }).done(function(msg) {
      $("#game").replaceWith(msg)
    });
    return false;
  });
}

function play_again() {
  $(document).on("click", "a#play_again_blackjack", function() {
    $.ajax({
      type: "GET",
      url: "/another_bet"
    }).done(function(msg) {
      $("#game").replaceWith(msg)
    });
    return false;
  });
}

// PICK 5 AJAX ----------- FOR BLACKJACK GO TO LINE

function play_again() {
  $(document).on("click", "a#play_again_blackjack", function() {
    $.ajax({
      type: "GET",
      url: "/another_bet"
    }).done(function(msg) {
      $("#game").replaceWith(msg)
    });
    return false;
  });
}


// go to start from the top... pick_five

function player_numbers() {
  $(document).on("click", "form#player_picks input#player_submit", function() {
    $.ajax({
      type: "GET",
      url: "/player_choice"
    }).done(function(msg) {
      $("#pick5").replaceWith(msg)
    });
    return false;
  });
}
