/**
* My BDD Test
*/
component extends='testbox.system.BaseSpec' {

	function run() {

        describe('initialization', function() {

            it('creates an empty object if neither a query nor an array is passed in', function() {
                var magicTable = new models.CFMagicTable();

                var expectedHeader = [];
                makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                expect(magicTable.getHeaderPublic()).toBe(expectedHeader);

                var expectedData = [];
                makePublic(magicTable, 'getData', 'getDataPublic');
                expect(magicTable.getDataPublic()).toBe(expectedData);
            });

            describe('`data` parameter', function() {

                it('accepts a query parameter', function() {
                    var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                        { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                        { id = 2, name = 'Donna Noble',      salary = 4800000 },
                        { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                        { id = 4, name = 'Rory Williams',    salary = 2650000 },
                        { id = 5, name = 'Sarah Jane Smith', salary = 2200000 },
                    ]);

                    var magicTable = new models.CFMagicTable(data = data);

                    var expectedHeader = [ 'id', 'name', 'salary' ];
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);

                    var expectedData = [
                        [ 1, 'Jack Harkness', 5800000 ],
                        [ 2, 'Donna Noble', 4800000 ],
                        [ 3, 'Clara Oswald', 6200000 ],
                        [ 4, 'Rory Williams', 2650000 ],
                        [ 5, 'Sarah Jane Smith', 2200000 ]
                    ];
                    makePublic(magicTable, 'getData', 'getDataPublic');
                    expect(magicTable.getDataPublic()).toBe(expectedData);
                });

                it('accepts an array parameter', function() {
                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];

                    var magicTable = new models.CFMagicTable(data = data);

                    var expectedHeader = [];
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);

                    var expectedData = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];
                    makePublic(magicTable, 'getData', 'getDataPublic');
                    expect(magicTable.getDataPublic()).toBe(expectedData);
                });

                it('accepts an array of structs and auto-discovers the column names (in alphabetical order)', function() {
                    var data = [
                        { votes = '58', day = 'Sunday'   },
                        { votes = '23', day = 'Monday'   },
                        { votes = '15', day = 'Tuesday'  },
                        { votes = '62', day = 'Wednesday'},
                        { votes = '74', day = 'Thursday' },
                        { votes = '88', day = 'Friday'   },
                        { votes = '23', day = 'Saturday' }
                    ];

                    var magicTable = new models.CFMagicTable(data = data);

                    var expectedHeader = ['day', 'votes'];
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);

                    var expectedData = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];
                    makePublic(magicTable, 'getData', 'getDataPublic');
                    expect(magicTable.getDataPublic()).toBe(expectedData);
                });

                it('accepts an array of (non-linked) structs (and sorts the keys in alphabetical order)', function() {
                    var sunday = structNew();
                    sunday.insert('votes', '58')
                    sunday.insert('day', 'Sunday');

                    var monday = structNew();
                    monday.insert('votes', '23')
                    monday.insert('day', 'Monday');

                    var tuesday = structNew();
                    tuesday.insert('votes', '15')
                    tuesday.insert('day', 'Tuesday');

                    var wednesday = structNew();
                    wednesday.insert('votes', '62')
                    wednesday.insert('day', 'Wednesday');

                    var thursday = structNew();
                    thursday.insert('votes', '74')
                    thursday.insert('day', 'Thursday');

                    var friday = structNew();
                    friday.insert('votes', '88')
                    friday.insert('day', 'Friday');

                    var saturday = structNew();
                    saturday.insert('votes', '23')
                    saturday.insert('day', 'Saturday');

                    var data = [ sunday, monday, tuesday, wednesday, thursday, friday, saturday ];

                    var magicTable = new models.CFMagicTable(data = data);

                    var expectedHeader = ['day', 'votes'];
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);

                    var expectedData = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];
                    makePublic(magicTable, 'getData', 'getDataPublic');
                    expect(magicTable.getDataPublic()).toBe(expectedData);
                });

                it('accepts an array of (linked) structs (which also preserve key order)', function() {
                    var sunday = structNew('linked');
                    sunday.insert('votes', '58')
                    sunday.insert('day', 'Sunday');

                    var monday = structNew('linked');
                    monday.insert('votes', '23')
                    monday.insert('day', 'Monday');

                    var tuesday = structNew('linked');
                    tuesday.insert('votes', '15')
                    tuesday.insert('day', 'Tuesday');

                    var wednesday = structNew('linked');
                    wednesday.insert('votes', '62')
                    wednesday.insert('day', 'Wednesday');

                    var thursday = structNew('linked');
                    thursday.insert('votes', '74')
                    thursday.insert('day', 'Thursday');

                    var friday = structNew('linked');
                    friday.insert('votes', '88')
                    friday.insert('day', 'Friday');

                    var saturday = structNew('linked');
                    saturday.insert('votes', '23')
                    saturday.insert('day', 'Saturday');

                    var data = [ sunday, monday, tuesday, wednesday, thursday, friday, saturday ];

                    var magicTable = new models.CFMagicTable(data = data);

                    var expectedHeader = ['votes', 'day'];
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);

                    var expectedData = [
                        ['58', 'Sunday'],
                        ['23', 'Monday'],
                        ['15', 'Tuesday'],
                        ['62', 'Wednesday'],
                        ['74', 'Thursday'],
                        ['88', 'Friday'],
                        ['23', 'Saturday']
                    ];
                    makePublic(magicTable, 'getData', 'getDataPublic');
                    expect(magicTable.getDataPublic()).toBe(expectedData);
                });

                it('accepts an array of Java LinkedHashMaps (which preserve key order)', function() {
                    var sunday = createObject('java', 'java.util.LinkedHashMap').init();
                    sunday.put('votes', '58')
                    sunday.put('day', 'Sunday');

                    var monday = createObject('java', 'java.util.LinkedHashMap').init();
                    monday.put('votes', '23')
                    monday.put('day', 'Monday');

                    var tuesday = createObject('java', 'java.util.LinkedHashMap').init();
                    tuesday.put('votes', '15')
                    tuesday.put('day', 'Tuesday');

                    var wednesday = createObject('java', 'java.util.LinkedHashMap').init();
                    wednesday.put('votes', '62')
                    wednesday.put('day', 'Wednesday');

                    var thursday = createObject('java', 'java.util.LinkedHashMap').init();
                    thursday.put('votes', '74')
                    thursday.put('day', 'Thursday');

                    var friday = createObject('java', 'java.util.LinkedHashMap').init();
                    friday.put('votes', '88')
                    friday.put('day', 'Friday');

                    var saturday = createObject('java', 'java.util.LinkedHashMap').init();
                    saturday.put('votes', '23')
                    saturday.put('day', 'Saturday');

                    var data = [ sunday, monday, tuesday, wednesday, thursday, friday, saturday ];

                    var magicTable = new models.CFMagicTable(data = data);

                    var expectedHeader = ['votes', 'day'];
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);

                    var expectedData = [
                        ['58', 'Sunday'],
                        ['23', 'Monday'],
                        ['15', 'Tuesday'],
                        ['62', 'Wednesday'],
                        ['74', 'Thursday'],
                        ['88', 'Friday'],
                        ['23', 'Saturday']
                    ];
                    makePublic(magicTable, 'getData', 'getDataPublic');
                    expect(magicTable.getDataPublic()).toBe(expectedData);
                });

            });

            describe('`header` parameter', function() {

                it('can accept an optional header array', function() {
                    var header = ['Day', 'Votes'];
                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];

                    var magicTable = new models.CFMagicTable(data = data, header = header);

                    var expectedHeader = ['Day', 'Votes'];
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);

                    var expectedData = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];
                    makePublic(magicTable, 'getData', 'getDataPublic');
                    expect(magicTable.getDataPublic()).toBe(expectedData);
                });

                it('overrides any discovered headers when the parameter is passed in', function() {
                    var header = ['Unique Id', 'Companion Name', 'Companion Salary'];
                    var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                        { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                        { id = 2, name = 'Donna Noble',      salary = 4800000 },
                        { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                        { id = 4, name = 'Rory Williams',    salary = 2650000 },
                        { id = 5, name = 'Sarah Jane Smith', salary = 2200000 },
                    ]);

                    var magicTable = new models.CFMagicTable(data = data, header = header);

                    var expectedHeader = ['Unique Id', 'Companion Name', 'Companion Salary'];;
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);

                    var expectedData = [
                        [ 1, 'Jack Harkness', 5800000 ],
                        [ 2, 'Donna Noble', 4800000 ],
                        [ 3, 'Clara Oswald', 6200000 ],
                        [ 4, 'Rory Williams', 2650000 ],
                        [ 5, 'Sarah Jane Smith', 2200000 ]
                    ];
                    makePublic(magicTable, 'getData', 'getDataPublic');
                    expect(magicTable.getDataPublic()).toBe(expectedData);
                });

                xdescribe('using the passed in header to determine column order', function() {

                    it('orders queries using the header parameter', function() {
                        fail('test not implmented yet');
                    });

                    it('orders arrays of structs using the header parameter', function() {
                        fail('test not implmented yet');
                    });

                });

            });

            describe('`renderer` parameter', function() {

                it('uses a default PlainHTMLRenderer', function() {
                    var magicTable = new models.CFMagicTable();

                    makePublic(magicTable, 'getRenderer', 'getRendererPublic');
                    expect(magicTable.getRendererPublic()).toBeInstanceOf('models.renderers.PlainHtmlRenderer');
                    expect(magicTable.getRendererPublic()).toBeInstanceOf('models.renderers.CFMagicTableRendererInterface');
                });

                it('can accept a custom renderer at initialization', function() {
                    var customRenderer = $mockbox.createStub(implements = 'models.renderers.CFMagicTableRendererInterface');

                    var magicTable = new models.CFMagicTable(renderer = customRenderer);

                    makePublic(magicTable, 'getRenderer', 'getRendererPublic');
                    expect(magicTable.getRendererPublic()).toBe(customRenderer);
                    expect(magicTable.getRendererPublic()).toBeInstanceOf('models.renderers.CFMagicTableRendererInterface');
                });

                it('throws an exception if the renderer is not an instance of CFMagicTableRendererInterface', function() {
                    var customRendererWithoutInterface = $mockbox.createStub();

                    expect(function() {
                        var magicTable = new models.CFMagicTable(renderer = customRendererWithoutInterface);
                    }).toThrow();
                });

            });


        });

        describe('sanitization', function() {

            when('data array items not the same length as each other', function() {

                it('throws an exception if on initialization', function() {
                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23', '54'], // This is the mistake that causes the exception
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];

                    expect(function() {
                        var magicTable = new models.CFMagicTable(data);
                    }).toThrow('ArrayLengthMismatchException');
                });

                it('throws an exception when reinitializing at runtime', function() {
                    var magicTable = new models.CFMagicTable();

                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23', '54'], // This is the mistake that causes the exception
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];

                    expect(function() {
                        magicTable.reinit(data);
                    }).toThrow('ArrayLengthMismatchException');

                });

                it('throws an exception when setting the data at runtime', function() {
                    var magicTable = new models.CFMagicTable();

                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23', '54'], // This is the mistake that causes the exception
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];

                    expect(function() {
                        magicTable.setData(data);
                    }).toThrow('ArrayLengthMismatchException');
                });

            });

            when('array of structs not the same keys as each other', function() {

                it('throws an exception on initialization', function() {
                    var data = [
                        { votes = '58', day = 'Sunday'   },
                        { votes = '23', day = 'Monday'   },
                        { votes = '15', day = 'Tuesday'  },
                        { votes = '62', day = 'Wednesday', percentage = '0.54' }, // This is the mistake that causes the exception
                        { votes = '74', day = 'Thursday' },
                        { votes = '88', day = 'Friday'   },
                        { votes = '23', day = 'Saturday' }
                    ];

                    expect(function() {
                        var magicTable = new models.CFMagicTable(data);
                    }).toThrow('StructKeyMismatchException');
                });

                it('throws an exception when reinitializing at runtime', function() {
                    var magicTable = new models.CFMagicTable();

                    var data = [
                        { votes = '58', day = 'Sunday'   },
                        { votes = '23', day = 'Monday'   },
                        { votes = '15', day = 'Tuesday'  },
                        { votes = '62', day = 'Wednesday', percentage = '0.54' }, // This is the mistake that causes the exception
                        { votes = '74', day = 'Thursday' },
                        { votes = '88', day = 'Friday'   },
                        { votes = '23', day = 'Saturday' }
                    ];

                    expect(function() {
                        magicTable.reinit(data);
                    }).toThrow(
                        type = 'StructKeyMismatchException',
                        message = 'Key mismatch found at index [4].  First keys were [day, votes]. Exception caused by [day, percentage, votes].'
                    );

                });

                it('throws an exception when setting the data at runtime', function() {
                    var magicTable = new models.CFMagicTable();

                    var data = [
                        { votes = '58', day = 'Sunday'   },
                        { votes = '23', day = 'Monday'   },
                        { votes = '15', day = 'Tuesday'  },
                        { votes = '62', day = 'Wednesday', percentage = '0.54' }, // This is the mistake that causes the exception
                        { votes = '74', day = 'Thursday' },
                        { votes = '88', day = 'Friday'   },
                        { votes = '23', day = 'Saturday' }
                    ];

                    expect(function() {
                        magicTable.setData(data);
                    }).toThrow(
                        type = 'StructKeyMismatchException',
                        message = 'Key mismatch found at index [4].  First keys were [day, votes]. Exception caused by [day, percentage, votes].'
                    );
                });

            });

            when('header array and data array items not the same length', function() {

                it('throws an exception on initialization', function() {
                    var header = ['Day', 'Votes', 'Percentage'];
                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23'], // This is the mistake that causes the exception
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];

                    expect(function() {
                        var magicTable = new models.CFMagicTable(data = data, header = header);
                    }).toThrow('ArrayLengthMismatchException');
                });

                it('throws an exception when setting the header at runtime', function() {
                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];
                    var magicTable = new models.CFMagicTable(data);

                    var header = ['Day', 'Votes', 'Percentage'];

                    expect(function() {
                        magicTable.setHeader(header);
                    }).toThrow('ArrayLengthMismatchException');

                });

                it('throws an exception when setting the data at runtime', function() {
                    var header = ['Day', 'Votes'];
                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];
                    var magicTable = new models.CFMagicTable(data = data, header = header);

                    var newData = [
                        ['Sunday'],
                        ['Monday'],
                        ['Tuesday'],
                        ['Wednesday'],
                        ['Thursday'],
                        ['Friday'],
                        ['Saturday']
                    ];

                    expect(function() {
                        magicTable.setData(newData);
                    }).toThrow('ArrayLengthMismatchException');
                });

            });

            when('footer array and data array items not the same length', function() {

                it('throws an exception on initialization', function() {
                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];
                    var footer = ['', '343', '100%']; // This is the mistake that causes the exception

                    expect(function() {
                        var magicTable = new models.CFMagicTable(data = data, footer = footer);
                    }).toThrow('ArrayLengthMismatchException');
                });

                it('throws an exception when setting the footer at runtime', function() {
                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];
                    var magicTable = new models.CFMagicTable(data);

                    var footer = ['', '343', '100%']; // This is the mistake that causes the exception

                    expect(function() {
                        magicTable.setFooter(footer);
                    }).toThrow('ArrayLengthMismatchException');
                });

                it('throws an exception when setting the data at runtime', function() {
                    var data = [
                        ['Sunday', '58'],
                        ['Monday', '23'],
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];
                    var footer = ['', '343'];
                    var magicTable = new models.CFMagicTable(data = data, footer = footer);

                    var badData = [
                        ['Sunday'],
                        ['Monday'],
                        ['Tuesday'],
                        ['Wednesday'],
                        ['Thursday'],
                        ['Friday'],
                        ['Saturday']
                    ];

                    expect(function() {
                        magicTable.setData(badData);
                    }).toThrow('ArrayLengthMismatchException');
                });

            });

            when('all array items not being either all structs or all arrays', function() {

                it('throws an exception on initialization', function() {
                    var data = [
                        ['Sunday', '58'],
                        { day = 'Monday', votes = '23'}, // This is the mistake that causes the exception
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];

                    expect(function() {
                        var magicTable = new models.CFMagicTable(data);
                    }).toThrow('ArrayTypeMismatchException');
                });

                it('throws an exception when reinitializing at runtime', function() {
                    var magicTable = new models.CFMagicTable();

                    var data = [
                        ['Sunday', '58'],
                        { day = 'Monday', votes = '23' }, // This is the mistake that causes the exception
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];

                    expect(function() {
                        magicTable.reinit(data);
                    }).toThrow(
                        type = 'ArrayTypeMismatchException',
                        message = 'Type mismatch found at index [2]. Items should be either all arrays or all structs.'
                    );

                });

                it('throws an exception when setting the data at runtime', function() {
                    var magicTable = new models.CFMagicTable();

                    var data = [
                        ['Sunday', '58'],
                        { day = 'Monday', votes = '23' }, // This is the mistake that causes the exception
                        ['Tuesday', '15'],
                        ['Wednesday', '62'],
                        ['Thursday', '74'],
                        ['Friday', '88'],
                        ['Saturday', '23']
                    ];

                    expect(function() {
                        magicTable.setData(data);
                    }).toThrow(
                        type = 'ArrayTypeMismatchException',
                        message = 'Type mismatch found at index [2]. Items should be either all arrays or all structs.'
                    );
                });

            });


        });

        describe('customizing', function() {

            describe('footer', function() {

                it('can accept static data for the footer', function() {
                    var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                        { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                        { id = 2, name = 'Donna Noble',      salary = 4800000 },
                        { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                        { id = 4, name = 'Rory Williams',    salary = 2650000 },
                        { id = 5, name = 'Sarah Jane Smith', salary = 2200000 },
                    ]);
                    var footer = ['', '', 21650000];

                    var magicTable = new models.CFMagicTable(data = data, footer = footer);

                    var expectedData = [
                        [ 1, 'Jack Harkness', 5800000 ],
                        [ 2, 'Donna Noble', 4800000 ],
                        [ 3, 'Clara Oswald', 6200000 ],
                        [ 4, 'Rory Williams', 2650000 ],
                        [ 5, 'Sarah Jane Smith', 2200000 ]
                    ];
                    makePublic(magicTable, 'getData', 'getDataPublic');
                    expect(magicTable.getDataPublic()).toBe(expectedData);

                    var expectedFooter = ['', '', 21650000];
                    makePublic(magicTable, 'getFooter', 'getFooterPublic');
                    expect(magicTable.getFooterPublic()).toBe(expectedFooter);
                });

                describe('column totals', function() {

                    it('can put column totals in the footer', function() {
                        var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                            { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                            { id = 2, name = 'Donna Noble',      salary = 4800000 },
                            { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                            { id = 4, name = 'Rory Williams',    salary = 2650000 },
                            { id = 5, name = 'Sarah Jane Smith', salary = 2200000 }
                        ]);

                        var magicTable = new models.CFMagicTable(data);
                        magicTable.totalColumns(3);

                        var expectedFooter = ['', '', 21650000];
                        makePublic(magicTable, 'getFooter', 'getFooterPublic');
                        expect(magicTable.getFooterPublic()).toBe(expectedFooter);
                    });

                    it('can total multiple columns using variadic arguments', function() {
                        var data = QueryNew('id,name,salary,votes', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer,cf_sql_integer', [
                            { id = 1, name = 'Jack Harkness',    salary = 5800000, votes = 23 },
                            { id = 2, name = 'Donna Noble',      salary = 4800000, votes = 12 },
                            { id = 3, name = 'Clara Oswald',     salary = 6200000, votes = 66 },
                            { id = 4, name = 'Rory Williams',    salary = 2650000, votes = 16 },
                            { id = 5, name = 'Sarah Jane Smith', salary = 2200000, votes = 5  }
                        ]);

                        var magicTable = new models.CFMagicTable(data);
                        magicTable.totalColumns(3, 4);

                        var expectedFooter = ['', '', 21650000, 122];
                        makePublic(magicTable, 'getFooter', 'getFooterPublic');
                        expect(magicTable.getFooterPublic()).toBe(expectedFooter);
                    });

                    it('can total multiple columns using a list as the first parameter', function() {
                        var data = QueryNew('id,name,salary,votes', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer,cf_sql_integer', [
                            { id = 1, name = 'Jack Harkness',    salary = 5800000, votes = 23 },
                            { id = 2, name = 'Donna Noble',      salary = 4800000, votes = 12 },
                            { id = 3, name = 'Clara Oswald',     salary = 6200000, votes = 66 },
                            { id = 4, name = 'Rory Williams',    salary = 2650000, votes = 16 },
                            { id = 5, name = 'Sarah Jane Smith', salary = 2200000, votes = 5  }
                        ]);

                        var magicTable = new models.CFMagicTable(data);
                        magicTable.totalColumns('3,4');

                        var expectedFooter = ['', '', 21650000, 122];
                        makePublic(magicTable, 'getFooter', 'getFooterPublic');
                        expect(magicTable.getFooterPublic()).toBe(expectedFooter);
                    });

                    it('throws an exception if it encounters a non-numeric value', function() {
                        var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                            { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                            { id = 2, name = 'Donna Noble',      salary = 4800000 },
                            { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                            { id = 4, name = 'Rory Williams',    salary = 2650000 },
                            { id = 5, name = 'Sarah Jane Smith', salary = 2200000 }
                        ]);

                        var magicTable = new models.CFMagicTable(data);

                        expect(function() {
                            magicTable.totalColumns(2);
                        }).toThrow('InvalidDataTypeException');
                    });

                });

                it('overrides the previous footer customization with the new one when called', function() {
                    var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                        { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                        { id = 2, name = 'Donna Noble',      salary = 4800000 },
                        { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                        { id = 4, name = 'Rory Williams',    salary = 2650000 },
                        { id = 5, name = 'Sarah Jane Smith', salary = 2200000 }
                    ]);
                    var footer = ['', 'All the companions', ''];

                    var magicTable = new models.CFMagicTable(data = data, footer = footer);

                    makePublic(magicTable, 'getFooter', 'getFooterPublic');
                    expect(magicTable.getFooterPublic()).toBe(footer);

                    var magicTable = new models.CFMagicTable(data);
                    magicTable.totalColumns(3);

                    var expectedFooter = ['', '', 21650000];
                    makePublic(magicTable, 'getFooter', 'getFooterPublic');
                    expect(magicTable.getFooterPublic()).toBe(expectedFooter);
                });

            });

            describe('header', function() {

                it('can rename header columns by name', function() {
                    var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                        { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                        { id = 2, name = 'Donna Noble',      salary = 4800000 },
                        { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                        { id = 4, name = 'Rory Williams',    salary = 2650000 },
                        { id = 5, name = 'Sarah Jane Smith', salary = 2200000 }
                    ]);

                    var magicTable = new models.CFMagicTable(data);
                    magicTable.renameColumn(from = 'id', to = 'Primary Key');

                    var expectedHeader = [ 'Primary Key', 'name', 'salary' ];
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);
                });

                it('throws an exception when trying to rename a column by name that doesn''t exist', function() {
                    var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                        { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                        { id = 2, name = 'Donna Noble',      salary = 4800000 },
                        { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                        { id = 4, name = 'Rory Williams',    salary = 2650000 },
                        { id = 5, name = 'Sarah Jane Smith', salary = 2200000 }
                    ]);

                    var magicTable = new models.CFMagicTable(data);

                    expect(function() {
                        magicTable.renameColumn(from = 'nonExisitantColumn', to = 'Primary Key');
                    }).toThrow('ColumnNameNotFoundException');
                });

                it('can rename header columns by position', function() {
                    var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                        { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                        { id = 2, name = 'Donna Noble',      salary = 4800000 },
                        { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                        { id = 4, name = 'Rory Williams',    salary = 2650000 },
                        { id = 5, name = 'Sarah Jane Smith', salary = 2200000 }
                    ]);

                    var magicTable = new models.CFMagicTable(data);
                    magicTable.renameColumn(index = 1, to = 'Primary Key');

                    var expectedHeader = [ 'Primary Key', 'name', 'salary' ];
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);
                });

                it('throws an exception when trying to rename a column by position that doesn''t exist', function() {
                    var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                        { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                        { id = 2, name = 'Donna Noble',      salary = 4800000 },
                        { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                        { id = 4, name = 'Rory Williams',    salary = 2650000 },
                        { id = 5, name = 'Sarah Jane Smith', salary = 2200000 }
                    ]);

                    var magicTable = new models.CFMagicTable(data);

                    expect(function() {
                        magicTable.renameColumn(index = 4, to = 'Primary Key');
                    }).toThrow('ColumnIndexNotFoundException');
                });

                it('will rename by `from` over `index` if both are passed in', function() {
                    var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                        { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                        { id = 2, name = 'Donna Noble',      salary = 4800000 },
                        { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                        { id = 4, name = 'Rory Williams',    salary = 2650000 },
                        { id = 5, name = 'Sarah Jane Smith', salary = 2200000 }
                    ]);

                    var magicTable = new models.CFMagicTable(data);
                    magicTable.renameColumn(from = 'id', index = 2, to = 'Changed');

                    var expectedHeader = [ 'Changed', 'name', 'salary' ];
                    makePublic(magicTable, 'getHeader', 'getHeaderPublic');
                    expect(magicTable.getHeaderPublic()).toBe(expectedHeader);
                });

            });

            describe('renderer', function() {

                it('can set a default renderer at runtime', function() {
                    var customRenderer = $mockbox.createStub(implements = 'models.renderers.CFMagicTableRendererInterface');

                    var magicTable = new models.CFMagicTable();
                    magicTable.setRenderer(customRenderer);

                    makePublic(magicTable, 'getRenderer', 'getRendererPublic');
                    expect(magicTable.getRendererPublic()).toBe(customRenderer);
                    expect(magicTable.getRendererPublic()).toBeInstanceOf('models.renderers.CFMagicTableRendererInterface');
                });

                it('throws an exception if the renderer is not an instance of CFMagicTableRendererInterface', function() {
                    var customRendererWithoutInterface = $mockbox.createStub();

                    var magicTable = new models.CFMagicTable();

                    expect(function() {
                        magicTable.setRenderer(customRendererWithoutInterface);
                    }).toThrow();
                });

            });

        });

        describe('rendering', function() {

            it('uses a default HTML renderer', function() {
                var mockRenderer = $mockbox.createMock('models.renderers.PlainHtmlRenderer').$('render');
                var magicTable = new models.CFMagicTable(renderer = mockRenderer);

                magicTable.render();

                expect(mockRenderer.$once('render')).toBeTrue();
            });

            it('sends the header, data, and footer to the renderer when `render is called`', function() {
                var mockRenderer = $mockbox.createMock('models.renderers.PlainHtmlRenderer').$('render');

                var data = QueryNew('id,name,salary', 'cf_sql_integer,cf_sql_varchar,cf_sql_integer', [
                    { id = 1, name = 'Jack Harkness',    salary = 5800000 },
                    { id = 2, name = 'Donna Noble',      salary = 4800000 },
                    { id = 3, name = 'Clara Oswald',     salary = 6200000 },
                    { id = 4, name = 'Rory Williams',    salary = 2650000 },
                    { id = 5, name = 'Sarah Jane Smith', salary = 2200000 },
                ]);

                var magicTable = new models.CFMagicTable(data = data, renderer = mockRenderer);

                magicTable.render();

                var callLog = mockRenderer.$callLog().render[1];
                expect(callLog[1]).toBe(['id', 'name', 'salary']);
                expect(callLog[2]).toBe([
                    [1, 'Jack Harkness', 5800000],
                    [2, 'Donna Noble', 4800000],
                    [3, 'Clara Oswald', 6200000],
                    [4, 'Rory Williams', 2650000],
                    [5, 'Sarah Jane Smith', 2200000]
                ]);
                expect(callLog[3]).toBe([]);
            });

        });

	}

}
