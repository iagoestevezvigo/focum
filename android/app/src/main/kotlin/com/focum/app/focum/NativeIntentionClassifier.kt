package com.focum.app.focum

import java.util.Locale
import java.text.Normalizer

data class NativeIntentionCategory(
    val id: String,
    val labelRes: Int,
    val emoji: String,
    val keywords: List<String>,
)

object NativeIntentionClassifier {
    private val categories =
        listOf(
            NativeIntentionCategory(
                id = "learning",
                labelRes = R.string.category_learning,
                emoji = "\uD83C\uDF93",
                keywords =
                    listOf(
                        "étudier",
                        "apprendre",
                        "cours",
                        "lecture",
                        "lire",
                        "lernen",
                        "studieren",
                        "lesen",
                        "kurs",
                        "imparare",
                        "studiare",
                        "leggere",
                        "corso",
                        "estudar",
                        "ler",
                        "curso",
                        "study",
                        "learn",
                        "learning",
                        "course",
                        "read",
                        "english",
                        "flutter",
                        "programming",
                        "programacion",
                        "estudiar",
                        "aprender",
                        "clase",
                        "leer",
                    ),
            ),
            NativeIntentionCategory(
                id = "work",
                labelRes = R.string.category_work,
                emoji = "\uD83D\uDCBC",
                keywords =
                    listOf(
                        "travail",
                        "travailler",
                        "réunion",
                        "courriel",
                        "arbeit",
                        "arbeiten",
                        "besprechung",
                        "beruf",
                        "lavoro",
                        "lavorare",
                        "riunione",
                        "trabalho",
                        "trabalhar",
                        "reunião",
                        "escritório",
                        "work",
                        "email",
                        "meeting",
                        "client",
                        "slack",
                        "office",
                        "correo",
                        "trabajo",
                        "reunion",
                        "equipo",
                        "proyecto",
                    ),
            ),
            NativeIntentionCategory(
                id = "personal_growth",
                labelRes = R.string.category_personal_growth,
                emoji = "\uD83C\uDF31",
                keywords =
                    listOf(
                        "méditer",
                        "méditation",
                        "réflexion",
                        "développement",
                        "meditieren",
                        "meditation",
                        "tagebuch",
                        "entwicklung",
                        "meditare",
                        "riflettere",
                        "crescita",
                        "meditação",
                        "refletir",
                        "crescimento",
                        "journal",
                        "meditate",
                        "reflection",
                        "habit",
                        "mindfulness",
                        "meditar",
                        "reflexionar",
                        "crecer",
                        "rutina",
                    ),
            ),
            NativeIntentionCategory(
                id = "social",
                labelRes = R.string.category_social,
                emoji = "\uD83D\uDCAC",
                keywords =
                    listOf(
                        "appeler",
                        "discuter",
                        "amis",
                        "famille",
                        "anrufen",
                        "nachricht",
                        "freunde",
                        "familie",
                        "chiamare",
                        "messaggio",
                        "amici",
                        "famiglia",
                        "ligar",
                        "mensagem",
                        "amigos",
                        "família",
                        "message",
                        "text",
                        "call",
                        "chat",
                        "friends",
                        "family",
                        "whatsapp",
                        "mensaje",
                        "llamar",
                        "hablar",
                        "juan",
                        "madre",
                    ),
            ),
            NativeIntentionCategory(
                id = "health",
                labelRes = R.string.category_health,
                emoji = "\u2764\uFE0F",
                keywords =
                    listOf(
                        "santé",
                        "médecin",
                        "marcher",
                        "sport",
                        "gesundheit",
                        "arzt",
                        "laufen",
                        "schlafen",
                        "salute",
                        "medico",
                        "camminare",
                        "allenare",
                        "saúde",
                        "médico",
                        "caminhar",
                        "treinar",
                        "health",
                        "doctor",
                        "walk",
                        "sleep",
                        "gym",
                        "exercise",
                        "salud",
                        "entrenar",
                        "correr",
                        "medico",
                    ),
            ),
            NativeIntentionCategory(
                id = "travel",
                labelRes = R.string.category_travel,
                emoji = "\u2708\uFE0F",
                keywords =
                    listOf(
                        "voyage",
                        "voyager",
                        "vol",
                        "itinéraire",
                        "reisen",
                        "reise",
                        "flug",
                        "karte",
                        "viaggio",
                        "viaggiare",
                        "volo",
                        "mappa",
                        "viagem",
                        "viajar",
                        "voo",
                        "travel",
                        "trip",
                        "restaurant",
                        "hotel",
                        "maps",
                        "route",
                        "viaje",
                        "vuelo",
                        "restaurante",
                        "mapa",
                    ),
            ),
            NativeIntentionCategory(
                id = "personal",
                labelRes = R.string.category_personal,
                emoji = "\uD83C\uDFE0",
                keywords =
                    listOf(
                        "maison",
                        "banque",
                        "acheter",
                        "achats",
                        "haus",
                        "bank",
                        "kaufen",
                        "einkaufen",
                        "casa",
                        "banca",
                        "comprare",
                        "spesa",
                        "compras",
                        "conta",
                        "calendário",
                        "home",
                        "bank",
                        "buy",
                        "shopping",
                        "calendar",
                        "personal",
                        "casa",
                        "comprar",
                        "banco",
                        "factura",
                    ),
            ),
            NativeIntentionCategory(
                id = "other",
                labelRes = R.string.category_other,
                emoji = "...",
                keywords = listOf("other", "otro"),
            ),
        )

    private fun normalize(value: String): String =
        Normalizer.normalize(value.lowercase(Locale.ROOT), Normalizer.Form.NFD)
            .replace(Regex("\\p{M}+"), "")
            .replace("ß", "ss")
            .replace("œ", "oe")

    fun categories(): List<NativeIntentionCategory> = categories

    fun classify(text: String): NativeIntentionCategory {
        val normalized = normalize(text)
        var bestCategory = categories.last()
        var bestScore = 0

        for (category in categories) {
            var score = 0
            for (keyword in category.keywords) {
                if (normalized.contains(normalize(keyword))) {
                    score += 1
                }
            }
            if (score > bestScore) {
                bestScore = score
                bestCategory = category
            }
        }

        return if (bestScore == 0) categories.last() else bestCategory
    }
}
