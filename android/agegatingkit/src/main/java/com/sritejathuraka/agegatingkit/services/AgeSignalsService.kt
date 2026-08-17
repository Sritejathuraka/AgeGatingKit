package com.sritejathuraka.agegatingkit.services

import android.app.Activity
import com.google.android.play.agesignals.AgeSignalsAccessRequest
import com.google.android.play.agesignals.AgeSignalsManager
import com.google.android.play.agesignals.AgeSignalsManagerFactory
import com.google.android.play.agesignals.AgeSignalsRequest
import com.google.android.play.agesignals.model.AgeSignalsStatus
import com.sritejathuraka.agegatingkit.models.AgeGatingResult
import com.sritejathuraka.agegatingkit.models.AgeRangeResult
import com.sritejathuraka.agegatingkit.models.AgeSignalsAccessResult
import com.sritejathuraka.agegatingkit.models.SignificantChangeStatus

internal class AgeSignalsService(
    private val activity: Activity
) {
    private val manager: AgeSignalsManager = AgeSignalsManagerFactory.create(
        activity.applicationContext
    )

    fun requestAgeSignalsAccess(
        onSuccess:(AgeSignalsAccessResult) -> Unit,
        onFailure: (Exception) -> Unit
    ) {
        val request = AgeSignalsAccessRequest.builder()
            .setActivity(activity)
            .build()
        manager.requestAgeSignalsAccess(request)
            .addOnSuccessListener { result ->
                val accessResult = when (result.ageSignalsStatus()) {
                    AgeSignalsStatus.SHARED -> AgeSignalsAccessResult.SHARED
                    AgeSignalsStatus.NOT_SHARED -> AgeSignalsAccessResult.NOT_SHARED
                    AgeSignalsStatus.UNSPECIFIED -> AgeSignalsAccessResult.UNSPECIFIED
                    AgeSignalsStatus.VERIFICATION_REQUIRED -> AgeSignalsAccessResult.VERIFICATION_REQUIRED
                    else -> AgeSignalsAccessResult.NOT_SHARED

                }
                onSuccess(accessResult)
            }
            .addOnFailureListener { exception ->
                onFailure(exception)
            }
    }

    fun checkAgeSignals(
        onSuccess: (AgeGatingResult) -> Unit,
        onFailure: (Exception) -> Unit
    ) {
        val request =
            AgeSignalsRequest.builder()
                .build()
        manager.checkAgeSignals(request)
            .addOnSuccessListener { result ->
                val ageRange =
                    if (
                        result.ageLower() != null ||
                        result.ageUpper() != null
                    ) {
                        AgeRangeResult(
                            lowerBound = result.ageLower(),
                            upperBound = result.ageUpper()
                        )
                    } else {
                        null
                    }
                val significantChangeStatus =
                    when (result.significantChangeStatus()?.toString()) {
                        "APPROVED" ->
                            SignificantChangeStatus.APPROVED
                        "PENDING" ->
                            SignificantChangeStatus.PENDING
                        "DECLINED" ->
                            SignificantChangeStatus.DECLINED
                        null ->
                            null
                        else ->
                            SignificantChangeStatus.UNKNOWN
                    }
                val ageGatingResult =
                    AgeGatingResult(
                        ageRange = ageRange,
                        ageRangeSource = result.ageRangeSource()?.toString(),
                        significantChangeStatus = significantChangeStatus,
                        significantChangeApprovalDate = result.significantChangeApprovalDate(),
                        installId = result.installId()
                    )
                onSuccess(ageGatingResult)
            }
            .addOnFailureListener { exception ->
                onFailure(exception)
            }
    }

}