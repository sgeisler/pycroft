/*!
 * Copyright (c) 2014 The Pycroft Authors. See the AUTHORS file.
 * This file is part of the Pycroft project and licensed under the terms of
 * the Apache License, Version 2.0. See the LICENSE file for details.
 */
/**
 * form.js
 *
 * This file contains javascript code used with the forms
 *
 * copyright (c) 2012, 2014 AG DSN.
 */

/**
 * This is a today-button to use with the datepicker.
 */
!function ( $ ) {

    // Today Button object
    var TodayButton = function (element, options) {
        this.element = $(element);
        this.target = $("#" + this.element.data("target"));
        this.datepicker = this.target.data("datepicker")
        this.dateFormat = this.datepicker.format;

        this.element.on('click', $.proxy(this.click, this));
    };

    TodayButton.prototype = {
        constructor:TodayButton,

        click:function (ev) {
            ev.preventDefault();
            this.target.val(this.formatDate(new Date()));
            this.datepicker.update()
        },

        formatDate:function (date) {
            var val = {
                d:date.getDate(),
                m:date.getMonth() + 1,
                yy:date.getFullYear().toString().substring(2),
                yyyy:date.getFullYear()
            };
            val.dd = (val.d < 10 ? '0' : '') + val.d;
            val.mm = (val.m < 10 ? '0' : '') + val.m;
            var date = [];
            for (var i = 0, cnt = this.dateFormat.parts.length; i < cnt; i++) {
                date.push(val[this.dateFormat.parts[i]]);
            }
            return date.join(this.dateFormat.separator);
        }
    };

    $.fn.todayButton = function (options) {
        return this.each(function () {
            if (undefined == $(this).data('todayButton')) {
                var plugin = new TodayButton(this, options);
                $(this).data('todayButton', plugin);
            }
        });
    };

    $.fn.todayButton.defaults = {};
	$.fn.todayButton.Constructor = TodayButton;

}(window.jQuery);

/**
 * AutoLoadFocus
 *
 * Automatically focuses the first input element of the first input group after
 * loading the page.
 */

$(function(){
    $(".form-group:first .controls:first :first").focus();
});


/**
 * The LazyLoadSelect plugin!
 *
 * This Plugin is used with the LazyLoadSelectField from web.form.fields.
 * It fetches new option values if one of the dependencies changes.
 */
!function ( $ ) {

    var LazyLoadSelect= function(element, options) {
        this.element = $(element);
        this.options = $.extend({
            field_ids: [],
            item_attr: "items"
            }, options);
        this.fields = [];
        this.itemAttr = this.options.item_attr;
        this.dataUrl = this.element.data("url");

        var field_ids = [];
        if (undefined != this.element.data("fieldids"))
            field_ids = field_ids.concat(this.element.data("fieldids").split(","));
        if (undefined != this.options.field_ids)
            field_ids = field_ids.concat(this.options.field_ids);

        for(var i = 0; i < field_ids.length; i++) {
            this.fields.push($("#" + field_ids[i]));
        }
        this.bind();
    };

    LazyLoadSelect.prototype = {
        constructor: LazyLoadSelect,

        bind: function() {
            for (var i = 0; i < this.fields.length; i++) {
                this.fields[i].on("change", $.proxy(this.reload, this));
            }
        },

        queryData: function(){
            var query_data = {};
            for (var i = 0; i < this.fields.length; i++) {
                var field = this.fields[i];
                query_data[field.attr("id")] = field.val();
            }
            return query_data
        },

        reload: function( ev, cb ) {
            var self = this;
            $.getJSON(this.dataUrl, this.queryData(), function(data){
                self.replaceOptions.call(self, data);
                if(cb) cb();
            });
        },

        replaceOptions: function(data) {
            var items = data[this.itemAttr];
            this.element.find("option").remove();
            for (var i = 0; i < items.length; i++) {
                if (typeof items[i] == 'object')
                    this.element.append('<option value="' + items[i][0] + '">' + items[i][1] + '</option>');
                else
                    this.element.append('<option value="' + items[i] + '">' + items[i] + '</option>');
            }
        }
    };

    $.fn.lazyLoadSelect = function (options) {
        var toPreload = [];
        function loadNext(){
            var next = toPreload.shift();
            if(next) next.reload.call(next, null, loadNext);
        }

        var result = this.each(function () {
            if (undefined == $(this).data('lazyLoadSelect')) {
                var plugin = new LazyLoadSelect(this, options);
                $(this).data('lazyLoadSelect', plugin);
                toPreload.push(plugin);
            }
        });

        loadNext();

        return result;
    };

    $.fn.lazyLoadSelect.defaults = {};
	$.fn.lazyLoadSelect.Constructor = LazyLoadSelect;

}(window.jQuery);


