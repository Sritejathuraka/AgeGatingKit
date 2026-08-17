package com.sritejathuraka.agegatingkit.models

import java.util.Date

data class AgeGatingResult(

    val ageRange: AgeRangeResult?,
    val ageRangeSource: String?,
    val significantChangeStatus: SignificantChangeStatus?,
    val significantChangeApprovalDate: Date?,
    val installId: String?

)