import 'package:flutter/material.dart';

class FoodLog extends StatefulWidget {
  FoodLog({Key? key, required this.foodList}) : super(key: key);
  final List<String> foodList;

  @override
  State<FoodLog> createState() => _FoodLogState();
}

class _FoodLogState extends State<FoodLog> {
  @override
  Widget build(BuildContext context) {
    int len = widget.foodList.length;
    return (len == 0)
        ? SliverList(
            delegate: SliverChildListDelegate(<Widget>[const Text('empty')]))
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final item = widget.foodList[index];
                return ((index == 0) || (index == (len - 1)))
                    ? firstOrLastItem(item, index, context)
                    : allOtherItems(
                        item, index, context); // Empty space for other indices
              },
              childCount: widget.foodList.length,
            ),
          );
  }

  Dismissible firstOrLastItem(String item, int index, BuildContext context) {

    return Dismissible(
      key: Key(item),
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          widget.foodList.removeAt(index);
        });

        // Then show a snackbar.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$item dismissed")),
        );
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this item?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("DELETE")),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
              ],
            );
          },
        );
      },
      background: Container(color: Colors.red),
      child: Container(
        height: (index == 0) ? 57 : 56,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Card(
          color: Colors.grey,
          shape: (index == 0) ? const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          ) : const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
          ),
          margin: EdgeInsets.only(bottom: 0, top: 0),
          elevation: 5,
          child: Column(
            children: [
              ListTile(
                shape: (index == 0 ) ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                ) : RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                ),
                title: Text(item),
                tileColor: Colors.grey,
              ),
              (index == 0) ? Divider(
                height: 1,
                color: Colors.black,
                thickness: 1,
              ) : Container()
            ],
          ),
        ),
      ),
    );
  }

  Dismissible allOtherItems(String item, int index, BuildContext context) {
    return Dismissible(
      key: Key(item),
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          widget.foodList.removeAt(index);
        });

        // Then show a snackbar.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$item dismissed")),
        );
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this item?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("DELETE")),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
              ],
            );
          },
        );
      },
      background: Container(color: Colors.red),
      child: Container(
        height: 57,
        width: 400,
        decoration: BoxDecoration(
        ),
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Card(
          color: Colors.grey,
          margin: EdgeInsets.only(bottom: 0, top: 0),
          elevation: 5,
          child: Column(
            children: [
              ListTile(
                shape: ContinuousRectangleBorder(),
                title: Text(item),
                tileColor: Colors.grey,
              ),
              Divider(
                height: 1,
                color: Colors.black,
                thickness: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}