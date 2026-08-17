package com.sritejathuraka.agegatingkit

import android.app.Activity
import com.sritejathuraka.agegatingkit.models.AgeGatingResult
import com.sritejathuraka.agegatingkit.models.AgeSignalsAccessResult
import com.sritejathuraka.agegatingkit.services.AgeSignalsService

object AgeGating {

    fun requestAgeSignalsAccess(
        activity: Activity,
        onSuccess: (AgeSignalsAccessResult) -> Unit,
        onFailure: (Exception) -> Unit
    ){
        AgeSignalsService(activity)
            .requestAgeSignalsAccess(
                onSuccess = onSuccess,
                onFailure = onFailure
            )
    }

    fun checkAgeSignals(
        activity: Activity,
        onSuccess: (AgeGatingResult) -> Unit,
        onFailure: (Exception) -> Unit
    ) {
        AgeSignalsService(activity)
            .checkAgeSignals(
                onSuccess = onSuccess,
                onFailure = onFailure
            )
    }
}