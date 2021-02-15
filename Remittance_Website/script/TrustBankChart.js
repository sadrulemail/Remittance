// Code By: Ashik Iqbal
// www.ashik.info
// Remittance

$(document).ready(function() {
    jQueryInit();
});

function pageLoad(sender, args) {
    if (args.get_isPartialLoad()) jQueryInit();    
}

function jQueryInit() {
    $(document).ready(function () {

        // Prevent the backspace key from navigating back.
        $(document).unbind('keydown').bind('keydown', function (event) {
            var doPrevent = false;
            if (event.keyCode === 8) {
                var d = event.srcElement || event.target;
                if ((d.tagName.toUpperCase() === 'INPUT' && (
                    d.type.toUpperCase() === 'TEXT'
                    || d.type.toUpperCase() === 'PASSWORD')
                    ) || d.tagName.toUpperCase() === 'TEXTAREA') {
                    doPrevent = d.readOnly || d.disabled;
                }
                else {
                    doPrevent = true;
                }
            }
            if (doPrevent) {
                event.preventDefault();
            }
        });

        //alert('s');

        $('.BEFTNSearchBox').autocomplete('BEFTN_Search.ashx', {
            width: 300,
            minChars: 1,
            cacheLength: 10,
            scrollHeight: 300,
            delay: 400,
            scroll: true,
            formatItem: function (data, i, n, value) {
                return "<table><tr><td valign='top' style='width:50px;'><img src='Banklogo/"
                + value.split(",")[3] + ".jpg' width='50px' /></td><td><span style='font-size:11pt;font-weight:bold;'>"
                + value.split(",")[0] + "</span><br />"
                + value.split(",")[1] + "<br />"
                + value.split(",")[2] + "<br />"
                + value.split(",")[4] + ", "
                + value.split(",")[5] + ""
                + "</td></tr><table>";
            },
            formatResult: function (data, value) {
                return value.split(",")[0];
            }
        });


        $(".emp-add-control-all").autocomplete("Search_EMP_ALL.ashx", {
            width: 300,
            minChars: 1,
            cacheLength: 10,
            scrollHeight: 500,
            delay: 400,
            scroll: true,
            formatItem: function (data, i, n, value) {
                return "<table><tr><td valign='top'><img src='"
                + value.split(",")[1] + "' width='60px' title='"
                + value.split(",")[2] + "' /></td><td>"
                + value.split(",")[0] + "</td></tr></table>";
            },
            formatResult: function (data, value) {
                return value.split(",")[2];
            }
        });

        $('input:text[Watermark]').each(function () {
            $(this).watermark($(this).attr('Watermark'));
        });

        $('#ctl00_ContentPlaceHolder2_radioCurrency').buttonset();

        $("time.timeago").timeago();
        $('#MenuDiv').show();

        $('.Date').datepicker({
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            dateFormat: 'dd/mm/yy',
            showAnim: 'show'
        });

        $('.Date').watermark('dd/mm/yyyy');


        //Datepicker Today Problem Resolve
        $.datepicker._gotoToday = function (id) {
            var target = $(id);
            var inst = this._getInst(target[0]);
            if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
                inst.selectedDay = inst.currentDay;
                inst.drawMonth = inst.selectedMonth = inst.currentMonth;
                inst.drawYear = inst.selectedYear = inst.currentYear;
            }
            else {
                var date = new Date();
                inst.selectedDay = date.getDate();
                inst.drawMonth = inst.selectedMonth = date.getMonth();
                inst.drawYear = inst.selectedYear = date.getFullYear();
                this._setDateDatepicker(target, date);
                this._selectDate(id, this._getDateDatepicker(target));
            }
            this._notifyChange(inst);
            this._adjustDate(target);
            //this.removeClass('ui-priority-secondary');
        }
        //--------------------------------------------------------------

        //    $('.ui-datepicker-current').live('click', function() {
        //        var associatedInputSelector = $(this).attr('onclick').replace(/^.*'(#[^']+)'.*/gi, '$1');
        //        var $associatedInput = $(associatedInputSelector).datepicker("setDate", new Date());
        //        $associatedInput.datepicker("hide");
        //    });


        var browser = "unknown";
        var userAgent = navigator.userAgent.toLowerCase();
        if (userAgent.indexOf("opera") > -1)
            browser = "Opera";
        else if (userAgent.indexOf("konqueror") > -1)
            browser = "Konqueror";
        else if (userAgent.indexOf("firefox") > -1)
            browser = "Mozilla Firefox";
        else if (userAgent.indexOf("netscape") > -1)
            browser = "Netscape";
        else if (userAgent.indexOf("msie") > -1)
            browser = "Internet Explorer";
        else if (userAgent.indexOf("chrome") > -1)
            browser = "Google Chrome";
        else if (userAgent.indexOf("safari") > -1)
            browser = "Safari";

        //var ip = new java.net.InetAddress.getLocalHost();

        $('.BrowserInformation').html(browser + ' ' + $.browser.version);
    });

}