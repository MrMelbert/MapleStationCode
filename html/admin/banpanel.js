<<<<<<< HEAD
function toggle_head(source, ext) {
    document.getElementById(source.id.slice(0, -4) + ext).checked = source.checked;
}

function toggle_checkboxes(source, ext) {
    var checkboxes = document.getElementsByClassName(source.name);
    for (var i = 0, n = checkboxes.length; i < n; i++) {
        checkboxes[i].checked = source.checked;
        if (checkboxes[i].id) {
            var idfound = document.getElementById(checkboxes[i].id.slice(0, -4) + ext);
            if (idfound) {
                idfound.checked = source.checked;
            }
        }
=======
function toggle_other_checkboxes(source, copycats_str, our_index_str) {
    const copycats = parseInt(copycats_str);
    const our_index = parseInt(our_index_str);
    for (var i = 1; i <= copycats; i++) {
        if(i === our_index) {
            continue;
        }
        document.getElementById(source.id.slice(0, -1) + i).checked = source.checked;
>>>>>>> tg/master
    }
}
