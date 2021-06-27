function ToggleSearch() {
    var x = document.getElementById("Search");
    if (x.style.display === "none") {
        x.style.display = "block";
    } else {
        x.style.display = "none";
    }
}

if(window.location.hash) {
    var hash = window.location.hash;
    
} else {

}