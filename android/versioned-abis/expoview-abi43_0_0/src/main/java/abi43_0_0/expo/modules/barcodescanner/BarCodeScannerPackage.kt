package abi43_0_0.expo.modules.barcodescanner

import android.content.Context
import abi43_0_0.expo.modules.core.BasePackage
import abi43_0_0.expo.modules.core.ExportedModule
import abi43_0_0.expo.modules.core.ViewManager
import abi43_0_0.expo.modules.core.interfaces.InternalModule

class BarCodeScannerPackage : BasePackage() {
  override fun createInternalModules(context: Context): List<InternalModule> {
    return listOf(BarCodeScannerProvider())
  }

  override fun createExportedModules(context: Context): List<ExportedModule> {
    return listOf(BarCodeScannerModule(context))
  }

  override fun createViewManagers(context: Context): List<ViewManager<*>> {
    return listOf(BarCodeScannerViewManager())
  }
}
