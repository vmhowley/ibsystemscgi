//Consult function
document.documentElement.classList.remove('no-js');
navigator.geolocation.getCurrentPosition(successCallback, errorCallback);

var consultFunction = function(event) {
    event.preventDefault();
    var asParms = {};
    data = '';
    asParms['F01'] = document.getElementById('selectId').value;
    asParms['F02'] = document.getElementById('identId').value;
    var tipSol = document.getElementById('tipSol').value;
    displayLoading()
    fetch("http://192.168.0.175/CONSULTA360/SERVICE/" + tipSol, {
        method: 'post',
        headers: new Headers({ 'Content-Type': 'application/json' }),
        body: JSON.stringify(asParms)
    }).then(function(response) {
        return response.text();
    }).then(function(data) {
        if (data == '0001') {
            hideLoading();
            $.NotificationApp.send("Error!", "Cliento no existe", "top-right", "rgba(0,0,0,0.2)", "error");

            document.getElementById('identId').value = '';
            document.getElementById('RESPONSE1').innerHTML = '';
            document.getElementById("RESPONSE3").innerHTML = '';
            document.getElementById("RESPONSE4").innerHTML = '';
            document.getElementById("RESPONSE5").innerHTML = '';
            document.getElementById('RESPONSE').innerHTML = '';
        } else {
            if (data == '0002') {
                hideLoading();
                $.NotificationApp.send("Error!", "Tarjeta no existe", "top-right", "rgba(0,0,0,0.2)", "error");

                document.getElementById('identId').value = '';
                document.getElementById('RESPONSE1').innerHTML = '';
                document.getElementById("RESPONSE3").innerHTML = '';
                document.getElementById("RESPONSE4").innerHTML = '';
                document.getElementById("RESPONSE5").innerHTML = '';
                document.getElementById('RESPONSE').innerHTML = '';
            } else {
                document.getElementById('identId').value = '';
                document.getElementById('RESPONSE1').innerHTML = '';
                document.getElementById("RESPONSE3").innerHTML = '';
                document.getElementById("RESPONSE4").innerHTML = '';
                document.getElementById("RESPONSE5").innerHTML = '';
                document.getElementById('RESPONSE').innerHTML = data;

                hideLoading();

                $(document).ready(function() {
                    "use strict";
                    $("#basic-datatable").DataTable({ keys: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } });
                    var a = $("#datatable-buttons").dataTable({ lengthChange: !1, buttons: ["copy", "print"], language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } });
                    $("#selection-datatable").DataTable({ select: { style: "multi" }, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), a.buttons().container().appendTo("#datatable-buttons_wrapper .col-md-6:eq(0)"), $("#alternative-page-datatable").DataTable({ pagingType: "full_numbers", drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#scroll-vertical-datatable").DataTable({ scrollY: "350px", scrollCollapse: !0, paging: !1, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#scroll-horizontal-datatable").DataTable({ scrollX: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#complex-header-datatable").DataTable({ language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") }, columnDefs: [{ visible: !1, targets: -1 }] }), $("#row-callback-datatable").DataTable({ language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") }, createdRow: function(a, e, t) { 15e4 < +e[5].replace(/[\$,]/g, "") && $("td", a).eq(5).addClass("text-danger") } }), $("#state-saving-datatable").DataTable({ stateSave: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $(".dataTables_length select").addClass("form-select form-select-sm"), $(".dataTables_length label").addClass("form-label")
                });
            }
        }
    });
};
document.getElementById("consultForm").addEventListener("submit", consultFunction, true);


// showing loading
function displayLoading() {
    const loader = document.querySelector("#loading");
    loader.classList.add("display");
    // to stop loading after some time
    setTimeout(() => {
        loader.classList.remove("display");
    }, 5000);
}

// hiding loading 
function hideLoading() {
    loader.classList.remove("display");
}

//==============================================================
function jsreload() {
    var head = document.getElementsByTagName('head')[0];
    var s = document.createElement('script');
    s.src = 'assets/js/pages/demo.datatable-init.js';
    document.body.appendChild(s);
    s.src = 'assets/js/vendor.min.js';
    head.appendChild(s);
}


//tc function================================================================

function tcFunction(id) {
    document.getElementById('RESPONSE1').innerHTML = '';
    document.getElementById("RESPONSE3").innerHTML = '';
    document.getElementById("RESPONSE4").innerHTML = '';
    document.getElementById("RESPONSE5").innerHTML = '';
    var td;
    td = document.getElementById("codcl" + id);
    var asParms = {};
    asParms['F01'] = '01';
    asParms['F02'] = td.innerHTML;
    var tipSol = 'VT';
    fetch("http://192.168.0.175/CONSULTA360/SERVICE/" + tipSol, {
        method: 'post',
        headers: new Headers({ 'Content-Type': 'application/json' }),
        body: JSON.stringify(asParms)
    }).then(function(response) {
        return response.text();
    }).then(function(data) {
        if (data == '0002') {
            $.NotificationApp.send("Error", "Cliente sin tarjeta", "top-right", "bg-danger", " dripicons-cross");
        } else {
            document.getElementById('RESPONSE1').innerHTML = data;
            var c = document.getElementsByTagName('td');
            var b;
            for (b = 0; b < c.length; b++) {
                c[b].classList.remove('table-primary');
            }
            document.getElementById('dataSelect' + id).classList.add('table-primary');

            document.getElementById("RESPONSE1").scrollIntoView();
        }
    });

};

//TC SELECT================================================================

function tcSelect(id) {
    document.getElementById("RESPONSE4").innerHTML = '';
    document.getElementById("RESPONSE5").innerHTML = '';
    var tipSol;
    var asParms = {};
    asParms['F01'] = '02';
    // asParms['F02'] = id;
    asParms['F02'] = document.getElementById("colum" + id).value;
    tipSol = 'TS';
    fetch("http://192.168.0.175/CONSULTA360/SERVICE/" + tipSol, {
        method: 'post',
        headers: new Headers({ 'Content-Type': 'application/json' }),
        body: JSON.stringify(asParms)
    }).then(function(response) {
        return response.text();
    }).then(function(data) {
        document.getElementById('RESPONSE2').innerHTML = data;

        // Get the modal
        var modal = document.getElementById("myModal");

        // Get the button that opens the modal
        var btn = document.getElementById("myBtn");

        // Get the <span> element that closes the modal
        var span = document.getElementsByClassName("btn-close")[0];

        // When the user clicks the button, open the modal 

        modal.style.display = "block";

        // When the user clicks on <span> (x), close the modal
        span.onclick = function() {
            modal.style.display = "none";
        }

        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }

        }
    });
};
//======SALDO==========================================================

function tcSaldo(moned) {
    var tipSol, asParms, modal1, btn, modal1, span, span1, accordion;
    asParms = {};
    asParms['F01'] = moned;
    asParms['F02'] = document.getElementById('tcv').innerHTML;
    tipSol = 'SW';
    fetch("http://192.168.0.175/CONSULTA360/SERVICE/" + tipSol, {
        method: 'post',
        headers: new Headers({ 'Content-Type': 'application/json' }),
        body: JSON.stringify(asParms)
    }).then(function(response) {
        return response.text();
    }).then(function(data) {
        modal = document.getElementById("myModal");
        modal.style.display = "none";
        document.getElementById("RESPONSE3").innerHTML = data;
        document.getElementById("minimicoll1").click();
    });

};

//======Saldo Actual==========================================================

function tcSaldotr() {
    var tipSol, asParms, accordion;
    const moned = document.getElementById('saldoval').value.substr(0, 2);
    asParms = {};
    asParms['F01'] = moned;
    asParms['F02'] = document.getElementById('tcv').innerHTML;
    tipSol = 'TR';
    fetch("http://192.168.0.175/CONSULTA360/SERVICE/" + tipSol, {
        method: 'post',
        headers: new Headers({ 'Content-Type': 'application/json' }),
        body: JSON.stringify(asParms)
    }).then(function(response) {
        return response.text();
    }).then(function(data) {
        if (data == '0001') {
            $.NotificationApp.send("Error", "Tarjeta no tiene transacciones", "top-right", "bg-secondary", " dripicons-cross");
            document.getElementById('RESPONSE1').innerHTML = '';
        } else {

            document.getElementById("RESPONSE5").innerHTML = data;
            document.getElementById("RESPONSE5").scrollIntoView();

            $(document).ready(function() {
                "use strict";
                $("#basic-datatable1").DataTable({ keys: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } });
                var a = $("#datatable-buttons").dataTable({ lengthChange: !1, buttons: ["copy", "print"], language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } });
                $("#selection-datatable").DataTable({ select: { style: "multi" }, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), a.buttons().container().appendTo("#datatable-buttons_wrapper .col-md-6:eq(0)"), $("#alternative-page-datatable").DataTable({ pagingType: "full_numbers", drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#scroll-vertical-datatable").DataTable({ scrollY: "350px", scrollCollapse: !0, paging: !1, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#scroll-horizontal-datatable").DataTable({ scrollX: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#complex-header-datatable").DataTable({ language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") }, columnDefs: [{ visible: !1, targets: -1 }] }), $("#row-callback-datatable").DataTable({ language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") }, createdRow: function(a, e, t) { 15e4 < +e[5].replace(/[\$,]/g, "") && $("td", a).eq(5).addClass("text-danger") } }), $("#state-saving-datatable").DataTable({ stateSave: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $(".dataTables_length select").addClass("form-select form-select-sm"), $(".dataTables_length label").addClass("form-label")
            });
        }
    });

};


//======Importe vencido==========================================================

function tcSaldovenc() {
    var tipSol, asParms, accordion;
    const moned = document.getElementById('saldoval').value.substr(0, 2);
    asParms = {};
    asParms['F01'] = moned;
    asParms['F02'] = document.getElementById('tcv').innerHTML;
    tipSol = 'SV';
    fetch("http://192.168.0.175/CONSULTA360/SERVICE/" + tipSol, {
        method: 'post',
        headers: new Headers({ 'Content-Type': 'application/json' }),
        body: JSON.stringify(asParms)
    }).then(function(response) {
        return response.text();
    }).then(function(data) {
        document.getElementById("RESPONSE4").innerHTML = data;



    });

};

function successCallback(position) {
    var latitude = position.coords.latitude;
    var longitude = position.coords.longitude;
    console.log("Latitude: " + latitude + ", Longitude: " + longitude);
}

function errorCallback(error) {
    console.log(error);
}