package net.placetomove.common.dto

import java.math.BigDecimal
import java.time.Instant

data class AdDto(
    val externalId: String,   // Наприклад: "olx-12345"
    val source: String,       // "OLX", "DOM_RIA"
    val title: String,
    val url: String,
    val price: BigDecimal,
    val currency: String,     // "USD", "UAH"
    val area: Double? = null, // Площа м²
    val description: String? = null,
    val images: List<String> = emptyList(),
    val location: RawLocation,
    val createdAt: Instant = Instant.now()
)

data class RawLocation(
    val city: String,
    val district: String? = null,
    val latitude: Double? = null,
    val longitude: Double? = null
)