extension EnumExt on Enum {
  String desc() {
    String name = this.name;
    return name[0].toUpperCase() + name.substring(1);
  }
}