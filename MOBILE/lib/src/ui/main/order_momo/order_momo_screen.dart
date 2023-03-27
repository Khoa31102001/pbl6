import 'package:base_code/src/api/global_api.dart';
import 'package:base_code/src/commons/widgets/loading_widget.dart';
import 'package:base_code/src/ui/main/order/order_screen.dart';
import 'package:base_code/src/utils/helpers.dart';
import 'package:base_code/src/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../blocs/order_momo_bloc.dart';
import '../../../models/order_momo/order_momo.dart';
import '../../../repositories/order_repo.dart';
import '../../../struct/app_color.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_strings.dart';
import 'package:base_code/src/utils/integer_extension.dart';
import 'package:base_code/src/utils/datetime_extension.dart';

class OrderMomoScreen extends StatefulWidget {
  const OrderMomoScreen({Key? key}) : super(key: key);

  @override
  State<OrderMomoScreen> createState() => _OrderMomoScreenState();
}

class _OrderMomoScreenState extends State<OrderMomoScreen> {
  late OrderMomoBloc _orderMomoBloc = OrderMomoBloc();
  final OrderRepository _orderRepository = OrderRepository();
  DataPagerController dataPagerController = DataPagerController();
  DataPagerDelegate dataPagerDelegate = DataPagerDelegate();
  Future receivedOrder(int idOrder) async {
     _orderRepository.receivedOrder(idOrder: idOrder);
  }
  String _nameStatus = "";
  void changeNameStatus(String status){
    switch(status){
      case "completed":
      _nameStatus = "Deliveried";
      break;
      case "on_preparing":
      _nameStatus = "Preparing";
      break;
      default:
      _nameStatus = "Payment";
      break;
    }
  }

  String get nameStatus => _nameStatus;
  @override
  Widget build(BuildContext context) {
    return Provider<OrderMomoBloc>(
      create: (context) => OrderMomoBloc(),
      dispose: (context, bloc) => bloc.dispose(),
      builder: (context, child) {
        _orderMomoBloc = context.read<OrderMomoBloc>();
        _orderMomoBloc.getListOrderMomo(1);
        return StreamBuilder<List<OrderMomo>>(
            stream: _orderMomoBloc.orderMomoStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<OrderMomo> orderMomos = snapshot.data!;
                if (orderMomos.isEmpty) {
                  return Image.asset(
                    AppImages.cartEmpty,
                    width: 300,
                    height: 300,
                  );
                }
                return Container(
                  decoration: const BoxDecoration(color: AppColors.pinkLight),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 100,
                        child: const Text(
                          AppStrings.order,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                OrderMomo orderMomo = orderMomos[index];
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderScreen(
                                              id: orderMomo.id,
                                            ),
                                          ));
                                    },
                                    child: _itemOrder(orderMomo));
                              },
                              separatorBuilder: (context, index) => Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: 2,
                                    color: Colors.black,
                                  ),
                              itemCount: orderMomos.length)),
                      SizedBox(height: 20,),
                      Center(
                        child: SfDataPager(
                          visibleItemsCount: 3,
                          pageCount: globalApi.totalPageOrderMomo?.floorToDouble() ?? 1,
                          controller: dataPagerController,
                          onPageNavigationStart: (pageIndex)  {
                            _orderMomoBloc.getListOrderMomo(pageIndex + 1);
                          },
                          initialPageIndex: 0,
                          direction: Axis.horizontal,
                          delegate: dataPagerDelegate,
                        ),
                      ),
                      SizedBox(height: 30,)
                    ],
                  ),
                );
              } else
                return loadingWidget;
            });
      },
    );
  }

  Widget _itemOrder(OrderMomo orderMomo) {
    changeNameStatus(orderMomo.status!);
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${orderMomo.orderItems?[0].productSize?.product?.name}" ??
                        '--',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    int.parse(orderMomo.total!.stringSplitZero).formatMoney,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderMomo.createdAt!.dateTimeToDDMMYYYY,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  nameStatus ?? "--",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Visibility(
              visible: nameStatus != "Deliveried",
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: (){
                     receivedOrder(orderMomo.id!);
                     showSuccessDialog(context, "Bạn đã xác nhận").then((value) => setState(() {
                       
                     },));
            
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(5),
                      decoration:  BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Colors.pink[400]),
                      child: const Text("RECEIVED" , style :TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white) )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
