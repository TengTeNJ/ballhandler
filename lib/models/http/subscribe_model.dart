class ApiPayProductVo{
  int productId = 0; // 商品编号
  String productImage = ''; // 商品图片
  String productName = ''; // 商品名称
  String productNo = ''; // 商品编码，和第三方平台的商品一致
  num productPrice = 0;  // 商品单价
  String productRemark = ''; // 商品描述
  int productTerm = 0; // 商品期限 单位为月
}
class SubscribeModel{
  int subscribeStatus = 0; // 订阅状态 0未订阅、1订阅中、2订阅过期、3订阅取消、4订阅暂停
  int subscribeTerm = 0; // 订阅周期 单位是月，如果值为1则代表按月 如果值是6则代表半年为一个周期
  String subscribeStartDate = ''; // 订阅开始日期
  String subscribeEndDate = ''; // 订阅结束日期
  ApiPayProductVo? productVo; // 商品信息
}