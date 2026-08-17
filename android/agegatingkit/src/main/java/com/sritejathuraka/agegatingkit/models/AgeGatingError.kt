package com.sritejathuraka.agegatingkit.models

sealed class AgeGatingError(
    message: String,
    cause: Throwable? = null
) : Exception(message, cause) {

    class ServiceUnavailable(
        cause: Throwable? = null
    ) : AgeGatingError(
        "Age Signals service is unavailable.",
        cause
    )
    class AccessNotShared :
        AgeGatingError(
            "Age Signals access was not shared."
        )
    class VerificationRequired :
        AgeGatingError(
            "Age verification is required."
        )
    class Unknown(
        cause: Throwable? = null
    ) : AgeGatingError(
        "An unknown Age Gating error occurred.",
        cause
    )
}