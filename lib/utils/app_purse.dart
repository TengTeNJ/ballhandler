import 'dart:async';
import 'dart:io';
import 'package:code/constants/constants.dart';
import 'package:code/utils/toast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../services/http/account.dart';

class AppPurse {
  StreamSubscription<dynamic>? _subscription;
  StreamSubscription<dynamic>  startSubscription() {
    if (this._subscription == null) {
      final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
      StreamSubscription<dynamic> _subscription =
          purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        print('-------onDone-------');
        //_subscription.cancel();
      }, onError: (error) {
        // handle error here.
        print('-------onError-------');
      });
      this._subscription = _subscription;
      return _subscription;
    } else {
      return this._subscription!;
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //_showPendingUI();
        TTToast.showLoading();
      } else {
        TTToast.hideLoading();
        if (purchaseDetails.status == PurchaseStatus.error) {
           InAppPurchase.instance.completePurchase(purchaseDetails);
          // _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // bool valid = await _verifyPurchase(purchaseDetails);
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
            // 去服务端进行验证
            if(purchaseDetails.pendingCompletePurchase){
              if(Platform.isAndroid){
                Account.googlePayVertify(
                  purchaseId: purchaseDetails.purchaseID ?? '',
                  productNo: purchaseDetails.productID,
                  purchaseToken:
                  purchaseDetails.verificationData.serverVerificationData,
                );
              }else{
                Account.applePayVertify(
                  thirdPayNo: purchaseDetails.purchaseID ?? '',
                  productNo: purchaseDetails.productID,
                  receiptDate:
                  purchaseDetails.verificationData.serverVerificationData,
                );
              }
            }
          }
        }else if(purchaseDetails.status == PurchaseStatus.canceled){
           InAppPurchase.instance.completePurchase(purchaseDetails);
        }

      }
    });
  }

  Future<bool> get avaliable async {
    final bool available = await InAppPurchase.instance.isAvailable();
    return available;
  }

  /*
  * 获取可购买的产品列表*/
  Future<List<ProductDetails>> getAvaliableProductList() async {
    const Set<String> _kIds = kProductIds;
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    return response.productDetails;
  }

  /*进行购买某个产品*/
  begainBuy(ProductDetails productDetail) async{
   final avaliable = await this.avaliable;
   if(avaliable){
     final PurchaseParam purchaseParam =
     PurchaseParam(productDetails: productDetail);
     await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
   }else{
    TTToast.showToast('Not avaliable');
   }

  }

  /*
  * 释放监听
  * */
  disposeSubscription(){
    if(this._subscription != null){
      this._subscription!.cancel();
    }
  }
}
