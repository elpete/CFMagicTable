component {

    variables.header = [];
    variables.data   = [];
    variables.footer = [];

	public CFMagicTable function init(data = [], header, models.renderers.CFMagicTableRendererInterface renderer) {
        this.setData(arguments.data);

        if (arguments.keyExists('header')) {
            this.setHeader(arguments.header);
        }

        if (arguments.keyExists('footer')) {
            this.setFooter(arguments.footer);
        }

        if (arguments.keyExists('renderer')) {
            variables.renderer = arguments.renderer;
        }
        else if (!variables.keyExists('renderer')) {
            variables.renderer = new models.renderers.PlainHtmlRenderer();
        }

		return this;
	}

    public function render() {
        variables.renderer.render(variables.header, variables.data, variables.footer);
    }

    // Syntactic sugar to reinitialize the table with a new array or query
    public CFMagicTable function reinit() {
        return this.init(argumentCollection = arguments);
    }

    public CFMagicTable function setData(required data) {
        if (IsQuery(arguments.data)) {
            variables.header = ListToArray(arguments.data.columnList);
            variables.data = this.queryToArray(arguments.data);
        }
        else if (IsArray(arguments.data)) {
            if (arguments.data.len() == 0) {
                variables.data = arguments.data;
                return this;
            }

            this.guardAgainstMixedTypes(arguments.data);

            if (isArrayOfStructs(arguments.data)) {
                this.guardAgainstMixedKeys(arguments.data);

                // Warning:
                // CFML doesn't respect key order when looping through structs
                // or retrieving the keys using StructKeyList or StructKeyArray.
                // Consider passing in either a linked struct or java LinkedHashMap
                variables.header = this.generateColumnNamesFromArrayOfStructs(arguments.data);
                variables.data = this.arrayOfStructsToArray(dataArray = arguments.data);
            }
            else {
                this.guardAgainstMixedLengths(arguments.data);// lengths within the array
                if (variables.header.len() > 0) {
                    this.guardAgainstMixedLengths(arguments.data, variables.header.len());
                }
                if (variables.footer.len() > 0) {
                    this.guardAgainstMixedLengths(arguments.data, variables.footer.len());
                }
                variables.data = arguments.data;
            }
        }

        return this;
    }

    public CFMagicTable function setHeader(required array header) {
        guardAgainstMixedLengths(variables.data, arguments.header.len());
        variables.header = arguments.header;

        return this;
    }

    public CFMagicTable function setFooter(required array footer) {
        guardAgainstMixedLengths(variables.data, arguments.footer.len());
        variables.footer = arguments.footer;

        return this;
    }

    public CFMagicTable function setRenderer(required models.renderers.CFMagicTableRendererInterface renderer) {
        variables.renderer = arguments.renderer;

        return this;
    }

    public CFMagicTable function totalColumns() {
        var args = [];
        if (!IsNumeric(arguments[1])) {
            args = ListToArray(arguments[1]);
        }
        else {
            for (var index in arguments) {
                args.append(arguments[index]);
            }
        }

        for (var columnIndex in args) {
            this.totalColumn(columnIndex);
        }

        return this;
    }

    private void function totalColumn(required numeric index) {
        var total = 0;
        for (var row in variables.data) {
            if (!IsNumeric(row[arguments.index])) {
                throw(type = "InvalidDataTypeException");
            }
            total += row[arguments.index];
        }

        variables.footer[arguments.index] = total;

        variables.footer = this.correctNulls(variables.footer);
    }

    public CFMagicTable function renameColumn(string from, numeric index, required string to) {
        var index = arguments.index ?: 0;
        if (arguments.keyExists('from')) {
            index = 0;
            for (var i = 1; i <= variables.header.len(); i++) {
                if (CompareNoCase(variables.header[i], arguments.from) == 0) {
                    index = i
                }
            }

            if (index == 0) {
                throw(type = 'ColumnNameNotFoundException');
            }
        }

        if (index > variables.header.len()) {
            throw(type = 'ColumnIndexNotFoundException');
        }

        variables.header.deleteAt(index);
        variables.header.insertAt(index, arguments.to);

        return this;
    }

    private array function queryToArray(required query query, array headerArray = variables.header) {
        var newArray = [];
        for (var row in arguments.query) {
            var newArrayItem = [];
            for (var columnName in arguments.headerArray) {
                newArrayItem.append(row[columnName]);
            }
            newArray.append(newArrayItem);
        }

        return newArray;
    }

    private void function guardAgainstMixedTypes(required array array) {
        var isFirstItemArray = IsArray(arguments.array[1]);
        for (var i = 1; i <= arguments.array.len(); i++) {
            if (IsArray(arguments.array[i]) != isFirstItemArray) {
                throw(
                    type = 'ArrayTypeMismatchException',
                    message = 'Type mismatch found at index [i].  Items should be either all arrays or all structs.'
                );
            }
        }

        return;
    }

    private void function guardAgainstMixedLengths(
        required array array,
        numeric guardLength = arguments.array[1].len()
    ) {
        for (var i = 1; i <= arguments.array.len(); i++) {
            if (arguments.array[i].len() != guardLength) {
                throw(
                    type = 'ArrayLengthMismatchException',
                    message = 'Length mismatch found at index [i].  Items should all be the same length.'
                );
            }
        }

        return;
    }

    private boolean function isArrayOfStructs(required array array) {
        return IsStruct(arguments.array[1]);
    }

    private void function guardAgainstMixedKeys(required array array) {
        var firstKeys = StructKeysToArray(arguments.array[1]).toList();

        for (var i = 1; i <= arguments.array.len(); i++) {
            var rowKeys = StructKeysToArray(arguments.array[i]).toList();
            if (rowKeys != firstKeys) {
                throw(
                    type = 'StructKeyMismatchException',
                    message = 'Key mismatch found at index [i].  First keys were [#firstKeys#]. Exception cause by [#rowKeys#].'
                );
            }
        }
    }

    private array function generateColumnNamesFromArrayOfStructs(required array array) {
        return StructKeysToArray(arguments.array[1]);
    }

    private array function StructKeysToArray(required struct struct) {
        if (IsInstanceOf(arguments.struct, 'java.util.LinkedHashMap')) {
            var javaArray = arguments.struct.keySet().toArray();
            var newArray = [];
            for (var item in javaArray) {
                newArray.append(item);
            }
            return newArray;
        }

        if (arguments.struct.getType() == 1 /* CreateObject('java', 'lucee.runtime.type.Struct').TYPE_LINKED */) {
            return arguments.struct.keyArray();
        }

        return arguments.struct.keyArray().sort('text', 'asc');
    }

    private array function ArrayOfStructsToArray(required array dataArray, array headerArray = variables.header) {
        var newArray = []
        for (var row in arguments.dataArray) {
            var newArrayItem = []
            for (var key in arguments.headerArray) {
                newArrayItem.append(row[key]);
            }
            newArray.append(newArrayItem);
        }

        return newArray;
    }

    private array function correctNulls(required array array) {
        var newArray = [];
        for (var item in arguments.array) {
            if (IsNull(item)) {
                newArray.append('');
            }
            else {
                newArray.append(item);
            }
        }
        return newArray;
    }

    private array function getHeader() {
        return variables.header;
    }

    private array function getData() {
        return variables.data;
    }

    private array function getFooter() {
        return variables.footer;
    }

    private models.renderers.CFMagicTableRendererInterface function getRenderer() {
        return variables.renderer;
    }


}
