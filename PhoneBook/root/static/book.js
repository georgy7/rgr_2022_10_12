window.addEventListener('DOMContentLoaded', (event) => {
    "use strict";

    let bookId = parseInt(document.querySelector('#book_id').value);

    function checkStatus(response) {
        if (response.status >= 200 && response.status < 300) {
            return Promise.resolve(response);
        } else {
            return Promise.reject(new Error(response.statusText));
        }
    }

    let app = new Vue({
        el: '#book',
        data: {
            loading: false,
            records: []
        },
        methods: {
            updateRecords: function () {
                let self = this;
                self.loading = true;

                fetch(`/book/${bookId}/records`).then(checkStatus).then(async response => {
                    self.records = (await response.json()).result;
                    self.loading = false;
                }).catch(error => {
                    self.loading = false;
                    console.log(error);
                });
            },
            editStart: function (record) {
                let self = this;
                Vue.set(record, 'newName', record.name);
                Vue.set(record, 'newPhone', record.phone);
                Vue.set(record, 'editErrors', []);
                Vue.set(record, 'edit', true);
            },
            editCancel: function (record) {
                let self = this;
                if (self.isNew(record)) {
                    self.$delete(self.records, self.records.indexOf(record));
                } else {
                    Vue.set(record, 'edit', false);
                }
            },
            editSave: function (record) {
                let self = this;

                let errors = [];

                if (('' + record.newName).length < 1) {
                    errors.push('Имя не может быть пустым.');
                }

                if (('' + record.newPhone).length < 1) {
                    errors.push('Телефон не может быть пустым.');
                } else if (!(('' + record.newPhone).trim().match(/^\+?(\d+|\-|\(|\)| )+$/))) {
                    errors.push('Телефон может содержать только цифры, дефисы, скобки, одинарные пробелы и плюс (в начале).');
                }

                if (errors.length) {
                    Vue.set(record, 'editErrors', errors);
                } else {
                    Vue.set(record, 'saving', true);

                    let formData = new FormData();
                    formData.append('name', record.newName);
                    formData.append('phone', record.newPhone);

                    let request = new XMLHttpRequest();

                    if (self.isNew(record)) {
                        request.open("POST", '/bookrecord');
                        formData.append('book_id', bookId);
                    } else {
                        request.open("POST", `/bookrecord?id=${record.book_record_id}`);
                    }

                    request.onload = function(event) {
                        if (request.status == 200) {
                            Vue.set(record, 'name', record.newName);
                            Vue.set(record, 'phone', record.newPhone);
                            Vue.set(record, 'edit', false);

                            if (self.isNew(record)) {
                                let id = JSON.parse(request.responseText).id;
                                Vue.set(record, 'book_record_id', id);
                            }

                        } else {
                            Vue.set(record, 'editErrors', [ 'Ошибка ' + request.status ]);
                        }

                        Vue.set(record, 'saving', false);
                    };

                    request.send(formData);
                }
            },
            isNew: function (record) {
                return isNaN(parseInt(record.book_record_id));
            },
            addRecord: function () {
                let self = this;
                let now = (new Date()).getTime();
                self.records.unshift({
                    book_record_id: `new_${now}`,
                    edit: true,
                    newName: '',
                    newPhone: '',
                    editErrors: []
                });
            },
            deleteRecord: function (record) {
                let self = this;

                // Вообще, тут следует использовать какой-то виджет,
                // т.к. некоторые браузеры блокируют такие окна.

                if (confirm(`Вы уверены, что хотите удалить запись ${record.name}?`)) {
                    Vue.set(record, 'saving', true);

                    let request = new XMLHttpRequest();
                    request.open("DELETE", `/bookrecord?id=${record.book_record_id}`);
                    request.onload = function(event) {
                        Vue.set(record, 'saving', false);
                        self.updateRecords();

                    };
                    request.send();
                }
            }
        }
    });

    app.updateRecords();
});
