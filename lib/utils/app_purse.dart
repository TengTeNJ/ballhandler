import 'dart:async';
import 'dart:io';
import 'package:code/constants/constants.dart';
import 'package:code/services/sqlite/data_base.dart';
import 'package:code/utils/http_util.dart';
import 'package:code/utils/toast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../services/http/account.dart';

class AppPurse {
  StreamSubscription<dynamic>? _subscription;

  StreamSubscription<dynamic> startSubscription() {
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
        TTToast.showLoading();
      } else {
        TTToast.hideLoading();
        // if (purchaseDetails.pendingCompletePurchase) {
        //   InAppPurchase.instance.completePurchase(purchaseDetails);
        //   return;
        // }
        if (purchaseDetails.status == PurchaseStatus.error ||
            purchaseDetails.status == PurchaseStatus.canceled) {
           DatabaseHelper().deletevSubPathData(purchaseDetails.productID);
          // 取消和出错的话要结束购买流程 否则下次再点击进来进行购买会pending
          InAppPurchase.instance.completePurchase(purchaseDetails);
          print('处理支付错误');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // bool valid = await _verifyPurchase(purchaseDetails);
          // 去服务端进行验证
          ApiResponse _response;
          if (Platform.isAndroid) {
            _response = await Account.googlePayVertify(
              purchaseId: purchaseDetails.purchaseID ?? '',
              productNo: purchaseDetails.productID,
              purchaseToken:
                  purchaseDetails.verificationData.serverVerificationData,
            );
          } else {
            _response = await Account.applePayVertify(
              thirdPayNo: purchaseDetails.purchaseID ?? '',
              productNo: purchaseDetails.productID,
              receiptDate:
                  purchaseDetails.verificationData.serverVerificationData,
            );
          }
          // 验证成功 则结束购买流程
          if (_response != null && _response.success) {
            InAppPurchase.instance.completePurchase(purchaseDetails);
            DatabaseHelper().deletevSubPathData(purchaseDetails.productID);
          }
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
  begainBuy(ProductDetails productDetail) async {
    final avaliable = await this.avaliable;
    if (avaliable) {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetail);
      await InAppPurchase.instance
          .buyNonConsumable(purchaseParam: purchaseParam);
       DatabaseHelper().insertSubData(productDetail);
    } else {
      TTToast.showToast('Not avaliable');
    }
  }

  /*
  * 释放监听
  * */
  disposeSubscription() {
    if (this._subscription != null) {
      this._subscription!.cancel();
    }
  }
}
