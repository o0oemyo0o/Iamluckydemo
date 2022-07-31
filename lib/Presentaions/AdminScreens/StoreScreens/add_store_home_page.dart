// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:iamlucky/Constants/app_constants.dart';
// import 'package:iamlucky/Constants/enums.dart';
// import 'package:iamlucky/GetControllers/admin_controller.dart';
// import 'package:iamlucky/GetControllers/city_controller.dart';
// import 'package:iamlucky/GetControllers/image_controller.dart';
// import 'package:iamlucky/GetControllers/store_controller.dart';
// import 'package:iamlucky/GetControllers/support_store_controller.dart';
// import 'package:iamlucky/Helpers/Responsive_UI/shared.dart';
// import 'package:iamlucky/Helpers/shared_texts.dart';
// import 'package:iamlucky/Models/city_model.dart';
// import 'package:iamlucky/Models/store_model.dart';
// import 'package:iamlucky/Models/support_store_model.dart';
// import 'package:iamlucky/Widgets/common_button.dart';
//
// import '../../TasksScreens/image_picker_widget.dart';
//
// class AddStoreHomePage extends StatefulWidget {
//   final SupportStoreModel? model;
//
//   const AddStoreHomePage({Key? key, this.model}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _AddStoreHomePageState();
// }
//
// class _AddStoreHomePageState extends State<AddStoreHomePage> {
//   final _storeController = Get.put(SupportStoreController());
//   final _imageController = Get.put(ImageController());
//   final _cityController = Get.put(CityController());
//   final _adminController = Get.put(AdminController());
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController latController = TextEditingController();
//   TextEditingController lngController = TextEditingController();
//
//   void addStoreFun() {
//     if (nameController.text.trim().isEmpty ||
//         latController.text.trim().isEmpty ||
//         lngController.text.trim().isEmpty ||
//         _imageController.storeImage == null) {
//       Get.snackbar('خطأ', 'الرجاء اكمال جميع البيانات',
//           backgroundColor: Colors.red);
//       return;
//     }
//
//     if (widget.model == null) {
//       _storeController.addNewStore(
//           name: nameController.text,
//           image: _storeController.storeUrl,
//           cityName: _cityController.dropdownValue!.value.name!,
//           cityID: _cityController.dropdownValue!.value.id!,
//           lat: double.parse(latController.text),
//           lng: double.parse(lngController.text));
//     } else {
//       _storeController.editStore(
//           storeID: widget.model!.id!,
//           name: nameController.text,
//           image: _storeController.storeUrl,
//           cityName: _cityController.dropdownValue!.value.name!,
//           cityID: _cityController.dropdownValue!.value.id!,
//           lat: double.parse(latController.text),
//           lng: double.parse(lngController.text));
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.model != null) {
//       nameController.text = widget.model!.name!;
//       latController.text = widget.model!.lat!.toString();
//       lngController.text = widget.model!.lng!.toString();
//
//       _cityController.dropdownValue = _adminController.cities
//           .where((element) => element.id == widget.model!.cityID!)
//           .first
//           .obs;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppConstants.mainColor,
//         title: Text(widget.model == null ? 'Add Store' : 'Edit Store'),
//       ),
//       body: Container(
//         height: SharedText.screenHeight,
//         width: SharedText.screenWidth,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//
//               /// Images
//               GetBuilder<ImageController>(
//                 builder: (ImageController logic) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       imageWidget(
//                           context: context,
//                           onTap: () async {
//                             await _imageController
//                                 .getImage(context, ImageTypes.storeImage)
//                                 .then((value) {
//                               _storeController.storeUrl = value;
//                             });
//                           },
//                           xFile: _imageController.storeImage,
//                           imageUrl: widget.model == null
//                               ? null
//                               : widget.model!.image!),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 10),
//
//               /// Name
//               const Text('Name',
//                   style: TextStyle(
//                       color: AppConstants.tealColor,
//                       fontSize: AppConstants.largeFontSize)),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(
//                         AppConstants.defaultButtonRadius)),
//                 child: TextField(
//                   controller: nameController,
//                   decoration: const InputDecoration(
//                       hintText: 'Store name', border: InputBorder.none),
//                 ),
//               ),
//               getSpaceHeight(25),
//
//               /// City
//               const Text(
//                 'City ',
//                 style: TextStyle(
//                     fontSize: AppConstants.largeFontSize,
//                     color: AppConstants.tealColor),
//               ),
//
//               const SizedBox(height: 10),
//
//               /// City DropDown
//               StreamBuilder(
//                   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }
//
//                     return Container(
//                       decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           borderRadius: BorderRadius.circular(
//                               AppConstants.defaultButtonRadius)),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: DropdownButton<CityModel>(
//                           hint: Text(_cityController.dropdownValue == null
//                               ? 'select your city'
//                               : _cityController.dropdownValue!.value.name!),
//                           icon: const Icon(Icons.arrow_downward),
//                           elevation: 16,
//                           style: const TextStyle(color: Colors.deepPurple),
//                           isExpanded: true,
//                           underline:
//                               Container(height: 2, color: Colors.transparent),
//                           onChanged: (CityModel? newValue) {
//                             setState(() {
//                               _cityController.dropdownValue = newValue!.obs;
//                             });
//                           },
//                           items: _adminController.cities
//                               .map<DropdownMenuItem<CityModel>>(
//                                   (CityModel value) {
//                             return DropdownMenuItem<CityModel>(
//                               value: value,
//                               child: Text(value.name!),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     );
//                   },
//                   stream: _adminController.loadCities()),
//               getSpaceHeight(25),
//
//               /// Lat
//               const Text('Latitude',
//                   style: TextStyle(
//                       color: AppConstants.tealColor,
//                       fontSize: AppConstants.largeFontSize)),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(
//                         AppConstants.defaultButtonRadius)),
//                 child: TextField(
//                   controller: latController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
//                   ],
//                   decoration: const InputDecoration(
//                       hintText: 'Lat', border: InputBorder.none),
//                 ),
//               ),
//               getSpaceHeight(25),
//
//               /// Lng
//               const Text('Longitude',
//                   style: TextStyle(
//                       color: AppConstants.tealColor,
//                       fontSize: AppConstants.largeFontSize)),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(
//                         AppConstants.defaultButtonRadius)),
//                 child: TextField(
//                   controller: lngController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
//                   ],
//                   decoration: const InputDecoration(
//                       hintText: 'Lng', border: InputBorder.none),
//                 ),
//               ),
//               getSpaceHeight(25),
//
//               /// Add | Edit Button
//               CommonButton(
//                 text: widget.model == null ? 'Add Store' : 'edit Store',
//                 onPressed: () {
//                   addStoreFun();
//                 },
//                 backgroundColor: AppConstants.mainColor,
//                 textColor: Colors.white,
//                 fontSize: AppConstants.mediumFontSize,
//               ),
//               getSpaceHeight(50),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
