import 'package:flutter/material.dart';
import 'dart:async';
import 'package:database_sqlite/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import 'entryform.dart';
import 'package:database_sqlite/item.dart';

//pendukung program asinkron
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Item> itemList;
  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = <Item>[];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Item -> 2031710062 Rachma Novita Anggreani'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: const Text("Tambah Item"),
              onPressed: () async {
                var item2 = null;
                var item = await navigateToEntryForm(context, item2);
                if (item != null) {
                  //TODO 2 Panggil Fungsi untuk Insert ke DB
                  int result = await dbHelper.insert(item);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.ad_units),
            ),
            title: Text(
              itemList[index].name,
              style: textStyle,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Rp." + itemList[index].price.toString()),
                const SizedBox(
                  height: 5.0,
                ),
                Text("Stok Barang : " + itemList[index].stok),
                Text("Kode Barang : " + itemList[index].kode),
              ],
            ),
            trailing: GestureDetector(
              child: const Icon(Icons.delete),
              onTap: () async {
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
                deleteItem(itemList[index]);
              },
            ),
            onTap: () async {
              var item = await navigateToEntryForm(context, itemList[index]);
              //TODO 4 Panggil Fungsi untuk Edit data
              editItem(itemList[index]);
            },
          ),
        );
      },
    );
  }

  //update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //TODO 1 Select data dari DB
      Future<List<Item>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          count = itemList.length;
        });
      });
    });
  }

  void deleteItem(Item object) async {
    int result = await dbHelper.delete(object.id);
    if (result > 0) {
      updateListView();
    }
  }

  void editItem(object) async {
    int result = await dbHelper.update(object);
    if (result > 0) {
      updateListView();
    }
  }
}
