// 交换数组中的某两个元素
void swapElements<T>(List<T> list, int index1, int index2) {
  if (index1 != index2) {
    T temp = list[index1];
    list[index1] = list[index2];
    list[index2] = temp;
  }
}