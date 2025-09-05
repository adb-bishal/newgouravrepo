import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';

import '../../../model/utils/color_resource.dart';
import '../../screens/root_view/live_classes_view/live_classes_view.dart';
import '../custom_list_tile/custom_list_tile.dart';

class CustomMultiselectDropDown extends StatefulWidget {
  final Function(DropDownData) selectedList;
  final List<DropDownData> listOFStrings;
  final List<DropDownData> listOFSStrings;
  final String errorText;
  final bool isLoading;

  const CustomMultiselectDropDown(
      {super.key,
      required this.selectedList,
      required this.listOFStrings,
      required this.listOFSStrings,
      required this.isLoading,
      required this.errorText});

  @override
  createState() {
    return _CustomMultiselectDropDownState();
  }
}

class _CustomMultiselectDropDownState extends State<CustomMultiselectDropDown> {
  // List<DropDownData> listOFSelectedItem = [];
  // DropDownData selectedText = DropDownData();
  @override
  void initState() {
    //listOFSelectedItem.addAll(widget.listOFSStrings);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSelectedWrap(widget.listOFSStrings, onClear: (index) {
          widget.selectedList(widget.listOFSStrings.elementAt(index));
          setState(() {
            widget.listOFSStrings.removeAt(index);
          });
        }),
        Container(
          // height: 45,
          padding: const EdgeInsets.only(top: 0),
          decoration: decoration(
              containerColor: Colors.transparent,
              borderColor: ColorResource.borderColor,
              radius: 11,
              width: 0.5),
          child: CustomExpansionTile(
            iconColor: ColorResource.lightDarkColor,
            title: Text(
              widget.listOFSStrings.isEmpty
                  ? widget.isLoading
                      ? "Loading..."
                      : "Select"
                  : widget.listOFSStrings[0].optionName ?? "",
              style: StyleResource.instance
                  .styleRegular(fontSize: DimensionResource.fontSizeSmall)
                  .copyWith(color: ColorResource.lightDarkColor),
            ),
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.listOFStrings.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6.0),
                    child: ViewItem(
                        item: widget.listOFStrings[index],
                        selected: (val) {
                          //selectedText = val;
                          if (widget.listOFSStrings
                              .any((element) => element.id == val.id)) {
                            widget.listOFSStrings
                                .removeWhere((element) => element.id == val.id);
                          } else {
                            widget.listOFSStrings.add(val);
                          }
                          widget.selectedList(val);
                          setState(() {});
                        },
                        itemSelected: widget.listOFSStrings.any((element) =>
                            element.id == widget.listOFStrings[index].id)),
                  );
                },
              ),
            ],
          ),
        ),
        widget.errorText == ""
            ? const SizedBox(
                height: 10,
              )
            : Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 15, top: 0, bottom: 8),
                child: Text(
                  widget.errorText,
                  style: StyleResource.instance.styleRegular().copyWith(
                        fontSize: DimensionResource.fontSizeExtraSmall,
                        color: ColorResource.redColor,
                      ),
                  textAlign: TextAlign.start,
                ),
              ),
      ],
    );
  }

  buildSelectedWrap(List<DropDownData> selectedService,
      {required Function(int) onClear}) {
    return Padding(
      padding: EdgeInsets.only(
          bottom:
              selectedService.isEmpty ? 0 : DimensionResource.marginSizeSmall),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 8.0,
        runSpacing: 4.0,
        children: List.generate(selectedService.length, (int index) {
          return IntrinsicWidth(
            child: GestureDetector(
              onTap: () {
                onClear(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorResource.secondaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        selectedService[index].optionName ?? "",
                        style: StyleResource.instance.styleRegular().copyWith(
                            fontSize: DimensionResource.fontSizeExtraSmall,
                            color: ColorResource.white),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: ColorResource.secondaryColor,
                            shape: BoxShape.circle),
                        padding: const EdgeInsets.all(0),
                        child: const Icon(
                          Icons.clear,
                          color: ColorResource.white,
                          size: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ViewItem extends StatelessWidget {
  DropDownData item;
  bool itemSelected;
  final Function(DropDownData) selected;

  ViewItem(
      {super.key,
      required this.item,
      required this.itemSelected,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
             item.optionName ?? "",
            style: StyleResource.instance.styleRegular(
                fontSize: DimensionResource.fontSizeSmall - 1,
                color: ColorResource.lightDarkColor),
          ),
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: const BorderSide(width: 0.4)),
              value: itemSelected,
              onChanged: (val) {
                selected(item);
              },
              activeColor: ColorResource.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration decoration(
    {Color? containerColor,
    Color? borderColor,
    double? width,
    double? radius = 0}) {
  return BoxDecoration(
      color: containerColor ?? ColorResource.primaryColor,
      border: Border.all(
          color: borderColor ?? ColorResource.borderColor, width: width ?? 1),
      borderRadius: BorderRadius.circular(radius!));
}
