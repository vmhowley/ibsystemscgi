document.documentElement.classList.remove("no-js");
var consultFunction = function(e) {
    e.preventDefault();
    var e = {},
        a = (data = "", e.F01 = document.getElementById("selectId").value, e.F02 = document.getElementById("identId").value, document.getElementById("tipSol").value);
    displayLoading(), fetch("http://192.168.0.175/CONSULTA360/SERVICE/" + a, { method: "post", headers: new Headers({ "Content-Type": "application/json" }), body: JSON.stringify(e) }).then(function(e) { return e.text() }).then(function(e) {
        "0001" == e ? (hideLoading(), $.NotificationApp.send("Error!", "Cliento no existe", "top-right", "rgba(0,0,0,0.2)", "error"), document.getElementById("identId").value = "", document.getElementById("RESPONSE1").innerHTML = "", document.getElementById("RESPONSE3").innerHTML = "", document.getElementById("RESPONSE4").innerHTML = "", document.getElementById("RESPONSE5").innerHTML = "", document.getElementById("RESPONSE").innerHTML = "") : "0002" == e ? (hideLoading(), $.NotificationApp.send("Error!", "Tarjeta no existe", "top-right", "rgba(0,0,0,0.2)", "error"), document.getElementById("identId").value = "", document.getElementById("RESPONSE1").innerHTML = "", document.getElementById("RESPONSE3").innerHTML = "", document.getElementById("RESPONSE4").innerHTML = "", document.getElementById("RESPONSE5").innerHTML = "", document.getElementById("RESPONSE").innerHTML = "") : (document.getElementById("identId").value = "", document.getElementById("RESPONSE1").innerHTML = "", document.getElementById("RESPONSE3").innerHTML = "", document.getElementById("RESPONSE4").innerHTML = "", document.getElementById("RESPONSE5").innerHTML = "", document.getElementById("RESPONSE").innerHTML = e, hideLoading(), $(document).ready(function() {
            "use strict";
            $("#basic-datatable").DataTable({ keys: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } });
            var e = $("#datatable-buttons").dataTable({ lengthChange: !1, buttons: ["copy", "print"], language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } });
            $("#selection-datatable").DataTable({ select: { style: "multi" }, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), e.buttons().container().appendTo("#datatable-buttons_wrapper .col-md-6:eq(0)"), $("#alternative-page-datatable").DataTable({ pagingType: "full_numbers", drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#scroll-vertical-datatable").DataTable({ scrollY: "350px", scrollCollapse: !0, paging: !1, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#scroll-horizontal-datatable").DataTable({ scrollX: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#complex-header-datatable").DataTable({ language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") }, columnDefs: [{ visible: !1, targets: -1 }] }), $("#row-callback-datatable").DataTable({ language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") }, createdRow: function(e, a, t) { 15e4 < +a[5].replace(/[\$,]/g, "") && $("td", e).eq(5).addClass("text-danger") } }), $("#state-saving-datatable").DataTable({ stateSave: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $(".dataTables_length select").addClass("form-select form-select-sm"), $(".dataTables_length label").addClass("form-label")
        }))
    })
};

function displayLoading() {
    const e = document.querySelector("#loading");
    e.classList.add("display"), setTimeout(() => { e.classList.remove("display") }, 5e3)
}

function hideLoading() { loader.classList.remove("display") }

function jsreload() {
    var e = document.getElementsByTagName("head")[0],
        a = document.createElement("script");
    a.src = "assets/js/pages/demo.datatable-init.js", document.body.appendChild(a), a.src = "assets/js/vendor.min.js", e.appendChild(a)
}

function tcFunction(n) {
    document.getElementById("RESPONSE1").innerHTML = "", document.getElementById("RESPONSE3").innerHTML = "", document.getElementById("RESPONSE4").innerHTML = "", document.getElementById("RESPONSE5").innerHTML = "", e = document.getElementById("codcl" + n);
    var e, a = {};
    a.F01 = "01", a.F02 = e.innerHTML;
    fetch("http://192.168.0.175/CONSULTA360/SERVICE/VT", { method: "post", headers: new Headers({ "Content-Type": "application/json" }), body: JSON.stringify(a) }).then(function(e) { return e.text() }).then(function(e) {
        if ("0002" == e) $.NotificationApp.send("Error", "Cliente sin tarjeta", "top-right", "bg-danger", " dripicons-cross");
        else {
            document.getElementById("RESPONSE1").innerHTML = e;
            for (var a = document.getElementsByTagName("td"), t = 0; t < a.length; t++) a[t].classList.remove("table-primary");
            document.getElementById("dataSelect" + n).classList.add("table-primary"), document.getElementById("RESPONSE1").scrollIntoView()
        }
    })
}

function tcSelect(e) {
    document.getElementById("RESPONSE4").innerHTML = "", document.getElementById("RESPONSE5").innerHTML = "";
    var a = {};
    a.F01 = "02", a.F02 = document.getElementById("colum" + e).value, fetch("http://192.168.0.175/CONSULTA360/SERVICE/TS", { method: "post", headers: new Headers({ "Content-Type": "application/json" }), body: JSON.stringify(a) }).then(function(e) { return e.text() }).then(function(e) {
        document.getElementById("RESPONSE2").innerHTML = e;
        var a = document.getElementById("myModal"),
            e = (document.getElementById("myBtn"), document.getElementsByClassName("btn-close")[0]);
        a.style.display = "block", e.onclick = function() { a.style.display = "none" }, window.onclick = function(e) { e.target == a && (a.style.display = "none") }
    })
}

function tcSaldo(e) {
    var a = {};
    a.F01 = e, a.F02 = document.getElementById("tcv").innerHTML, fetch("http://192.168.0.175/CONSULTA360/SERVICE/SW", { method: "post", headers: new Headers({ "Content-Type": "application/json" }), body: JSON.stringify(a) }).then(function(e) { return e.text() }).then(function(e) {
        (modal = document.getElementById("myModal")).style.display = "none", document.getElementById("RESPONSE3").innerHTML = e, document.getElementById("minimicoll1").click()
    })
}

function tcSaldotr() {
    var e = document.getElementById("saldoval").value.substr(0, 2),
        a = {};
    a.F01 = e, a.F02 = document.getElementById("tcv").innerHTML, fetch("http://192.168.0.175/CONSULTA360/SERVICE/TR", { method: "post", headers: new Headers({ "Content-Type": "application/json" }), body: JSON.stringify(a) }).then(function(e) { return e.text() }).then(function(e) {
        "0001" == e ? ($.NotificationApp.send("Error", "Tarjeta no tiene transacciones", "top-right", "bg-secondary", " dripicons-cross"), document.getElementById("RESPONSE1").innerHTML = "") : (document.getElementById("RESPONSE5").innerHTML = e, document.getElementById("RESPONSE5").scrollIntoView(), $(document).ready(function() {
            "use strict";
            $("#basic-datatable1").DataTable({ keys: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } });
            var e = $("#datatable-buttons").dataTable({ lengthChange: !1, buttons: ["copy", "print"], language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } });
            $("#selection-datatable").DataTable({ select: { style: "multi" }, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), e.buttons().container().appendTo("#datatable-buttons_wrapper .col-md-6:eq(0)"), $("#alternative-page-datatable").DataTable({ pagingType: "full_numbers", drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#scroll-vertical-datatable").DataTable({ scrollY: "350px", scrollCollapse: !0, paging: !1, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#scroll-horizontal-datatable").DataTable({ scrollX: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $("#complex-header-datatable").DataTable({ language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") }, columnDefs: [{ visible: !1, targets: -1 }] }), $("#row-callback-datatable").DataTable({ language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") }, createdRow: function(e, a, t) { 15e4 < +a[5].replace(/[\$,]/g, "") && $("td", e).eq(5).addClass("text-danger") } }), $("#state-saving-datatable").DataTable({ stateSave: !0, language: { paginate: { previous: "<i class='mdi mdi-chevron-left'>", next: "<i class='mdi mdi-chevron-right'>" } }, drawCallback: function() { $(".dataTables_paginate > .pagination").addClass("pagination-rounded") } }), $(".dataTables_length select").addClass("form-select form-select-sm"), $(".dataTables_length label").addClass("form-label")
        }))
    })
}

function tcSaldovenc() {
    var e = document.getElementById("saldoval").value.substr(0, 2),
        a = {};
    a.F01 = e, a.F02 = document.getElementById("tcv").innerHTML, fetch("http://192.168.0.175/CONSULTA360/SERVICE/SV", { method: "post", headers: new Headers({ "Content-Type": "application/json" }), body: JSON.stringify(a) }).then(function(e) { return e.text() }).then(function(e) { document.getElementById("RESPONSE4").innerHTML = e })
}
document.getElementById("consultForm").addEventListener("submit", consultFunction, !0);