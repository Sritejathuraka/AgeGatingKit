package com.sritejathuraka.agegatingkit.models

data class AgeGatingResult(

    val ageRange: AgeRangeResult?,
    val verificationStatus: String?,
    val ageRangeSource: String?,
    val significantChangeStatus: String?

)