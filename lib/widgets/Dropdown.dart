import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DropDown extends StatelessWidget {
  final GlobalKey fbKey;
  final String attribute, labelText;
  final IconData labelIcon;
  final List<String> itemsList;

  DropDown({
    Key key,
    @required this.fbKey,
    this.attribute,
    this.labelIcon,
    this.labelText,
    this.itemsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: FormBuilder(
        key: fbKey,
        autovalidate: true,
//        initialValue: {
//          'country': 0,
//        },
        child: FormBuilderCustomField(
          attribute: attribute,
//          validators: [
//            FormBuilderValidators.required(),
//          ],
          formField: FormField(
            // key: _fieldKey,
            enabled: true,
            builder: (FormFieldState<dynamic> field) {
              return InputDecorator(
                decoration: InputDecoration(
                  labelText: labelText,
                  contentPadding:
                      EdgeInsets.only(top: 10.0, bottom: 0.0, left: 0),
                  border: InputBorder.none,
                ),
                child: DropdownButton(
                  isExpanded: true,
                  items: itemsList.map((option) {
                    return DropdownMenuItem(
                      child: Text("$option"),
                      value: option,
                    );
                  }).toList(),
                  value: field.value,
                  onChanged: (value) {
                    field.didChange(value);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
