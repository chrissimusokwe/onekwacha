import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onekwacha/utils/custom_colors_fonts.dart';
import 'package:onekwacha/models/marketplaceModel.dart';
import 'package:onekwacha/utils/global_strings.dart';
import 'package:intl/intl.dart';

class MerchantProductsScreen extends StatefulWidget {
  final int incomingData;
  final String merchantName;
  final String productsToken;
  final String productsUrl;
  final String userProductUrl;
  final String topUpUrl;
  final String merchantLogo;
  MerchantProductsScreen({
    this.incomingData,
    @required this.merchantName,
    @required this.productsUrl,
    @required this.productsToken,
    @required this.userProductUrl,
    @required this.merchantLogo,
    @required this.topUpUrl,
    Key key,
  }) : super(key: key);

  @override
  _MerchantProductsScreenState createState() => _MerchantProductsScreenState();
}

class _MerchantProductsScreenState extends State<MerchantProductsScreen> {
  ProductsModel getproductModel = new ProductsModel();
  Future<List<ProductsModel>> listSpeedModel;
  final currencyConvertor = new NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    listSpeedModel = getproductModel.fetchLiteSpeed(
        widget.productsUrl, widget.productsToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundShade,
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              widget.merchantName,
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: _getMarketplaceWidgets(),
      ),
      // bottomNavigationBar: BottomNavigation(
      //   incomingData: incomingData,
      // ),
    );
  }

  List<Widget> _getMarketplaceWidgets() {
    List<Widget> formWidget = new List();
    formWidget.add(
      SizedBox(
        height: 5,
      ),
    );
    formWidget.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/marketplace/' + widget.merchantLogo,
            width: 40,
          ),
          Text(
            'Purchase ' + widget.merchantName + ' products',
            style: TextStyle(
              fontSize: 18,
              //fontWeight: FontWeight.bold,
              //fontFamily: 'Metrophobic',
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
    formWidget.add(
      SizedBox(
        height: 20,
      ),
    );
    //List of merchants
    formWidget.add(
      Expanded(
        flex: 1,
        child: FutureBuilder<List<ProductsModel>>(
          future: listSpeedModel,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('This is the error: ' + snapshot.error.toString());
              return Text('Errored');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Loading Product List...',
                    style: TextStyle(
                      color: Colors.amber.shade700,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(),
                ],
              ));
            } else {
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List<ProductsModel> document = snapshot.data;
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        document[index].productCode,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        document[index].productDescription,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        document[index].productCategory ?? '',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.amber.shade900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        MyGlobalVariables.zmcurrencySymbol +
                                            currencyConvertor.format(
                                                double.parse(
                                                    document[index].price)),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'BaiJamJuree',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.navigate_next,
                                        color: Colors.grey.shade500,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    });
              }
            }
          },
        ),
      ),
    );
    return formWidget;
  }
}
