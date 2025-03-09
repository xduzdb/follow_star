//
//  STImagePickView.swift
//  StartTimeLine
//
//  Created by Lushitong on 2024/12/23.
//
import SwiftUI
import TZImagePickerController

struct STImagePickerView: UIViewControllerRepresentable {
    // MARK: - Properties
    @Binding var isPresented: Bool
    @Binding var selectedImages: [UIImage]
    var didFinishPicking: (([UIImage]) -> Void)?
    
    // MARK: - Configuration
    var maxImagesCount: Int = 1
    var allowPickingVideo: Bool = false
    var allowTakePicture: Bool = true
    var allowPickingOriginalPhoto: Bool = true
    
    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 当 isPresented 变为 true 时，展示图片选择器
        if isPresented, uiViewController.presentedViewController == nil {
            let imagePickerVc = TZImagePickerController()
            configureImagePicker(imagePickerVc, coordinator: context.coordinator)
            uiViewController.navigationController?.present(imagePickerVc, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    private func configureImagePicker(_ picker: TZImagePickerController, coordinator: Coordinator) {
        // 基本设置
        picker.maxImagesCount = 1
        // 正确设置 delegate
        picker.pickerDelegate = coordinator
        
        // UI 设置
//        picker.isNavigationBarHidden = true
        picker.statusBarStyle = .darkContent
//        picker.modalPresentationStyle = .fullScreen
        
        // 自定义颜色
        picker.iconThemeColor = .systemBlue
        picker.oKButtonTitleColorNormal = .systemBlue
        
        // 自定义文本
        picker.cancelBtnTitleStr = "取消"
        picker.doneBtnTitleStr = "完成"
    }
    
    // MARK: - Private Methods
    private func configurePickerSettings(_ picker: TZImagePickerController) {
        // 基本设置
        picker.maxImagesCount = maxImagesCount
        picker.allowPickingVideo = allowPickingVideo
        picker.allowTakePicture = allowTakePicture
        picker.allowPickingOriginalPhoto = allowPickingOriginalPhoto
        
        // UI 设置
        picker.isNavigationBarHidden = true
        picker.statusBarStyle = .lightContent
        picker.modalPresentationStyle = .fullScreen
        
        // 自定义颜色
        picker.iconThemeColor = .systemBlue
        picker.oKButtonTitleColorNormal = .systemBlue
        
        // 自定义文本
        picker.cancelBtnTitleStr = "取消"
        picker.doneBtnTitleStr = "完成"
        
        // 图片排序
        picker.sortAscendingByModificationDate = false
    }
    
}

// MARK: - Coordinator
extension STImagePickerView {
    class Coordinator: NSObject, TZImagePickerControllerDelegate {
        var parent: STImagePickerView
        
        init(parent: STImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
            parent.selectedImages = photos
            parent.didFinishPicking?(photos)
            parent.isPresented = false
        }
        
        func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
            parent.isPresented = false
        }
    }
}

extension View {
    func imagePickerSheet(
        isPresented: Binding<Bool>,
        selectedImages: Binding<[UIImage]>,
        maxImagesCount: Int = 9,
        didFinishPicking: (([UIImage]) -> Void)? = nil
    ) -> some View {
        background(
            STImagePickerView(
                isPresented: isPresented,
                selectedImages: selectedImages,
                didFinishPicking: didFinishPicking, maxImagesCount: maxImagesCount
            )
        )
    }
}
 
struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        STImagePickerView(isPresented: .constant(true), selectedImages: .constant([UIImage]()))
    }
}
