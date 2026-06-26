import Foundation

public enum FlowerKind: String, CaseIterable, Codable, Identifiable, Equatable {
    case daisy
    case rose
    case sunflower
    case tulip
    case lotus
    case lavender
    case orchid
    case cherryBlossom
    case poppy
    case hydrangea
    case peony
    case camellia
    case gardenia
    case jasmine
    case magnolia
    case hibiscus
    case marigold
    case chrysanthemum
    case dahlia
    case zinnia
    case carnation
    case daffodil
    case iris
    case bluebell
    case foxglove
    case snapdragon
    case anemone
    case ranunculus
    case freesia
    case geranium
    case begonia
    case azalea
    case rhododendron
    case wisteria
    case bougainvillea
    case morningGlory
    case sweetPea
    case pansy
    case violet
    case primrose
    case cosmos
    case aster
    case calendula
    case gerbera
    case lily
    case callaLily
    case lilyOfTheValley
    case amaryllis
    case clematis
    case honeysuckle
    case fuchsia
    case plumeria
    case birdOfParadise
    case protea
    case banksia
    case waratah
    case edelweiss
    case yarrow
    case cornflower
    case forgetMeNot
    case babyBreath
    case bleedingHeart
    case hollyhock
    case delphinium
    case lupine
    case phlox
    case verbena
    case salvia
    case beeBalm
    case echinacea
    case blackEyedSusan
    case hellebore
    case cyclamen
    case crocus
    case snowdrop
    case allium
    case gladiolus
    case canna
    case nasturtium
    case petunia
    case impatiens
    case lantana
    case nicotiana
    case stock
    case scabiosa
    case nigella
    case borage
    case chamomile
    case clover
    case heather
    case gorse
    case broom
    case queenAnnesLace
    case tansy
    case goldenrod
    case milkweed
    case passionflower
    case hoya
    case stephanotis
    case tuberose

    public var id: String { rawValue }

    public var displayName: String {
        profile.englishName
    }

    public var assetName: String {
        rawValue.kebabCased()
    }

    public var symbolName: String {
        Self.symbolNames[index % Self.symbolNames.count]
    }

    public var shortDescription: String {
        englishInfo.shortDescription
    }

    public var facts: [String] {
        englishInfo.facts
    }

    public static func random() -> FlowerKind {
        allCases.randomElement() ?? .daisy
    }

    public var englishInfo: FlowerLocalizedInfo {
        FlowerLocalizedInfo(
            name: profile.englishName,
            shortDescription: profile.englishDescription,
            facts: [
                profile.englishNote,
                "Its varieties can differ widely in color, size, scent, or blooming season.",
                "In FlowerDoro, this bloom adds another collectible shape to the garden."
            ]
        )
    }

    public var vietnameseInfo: FlowerLocalizedInfo {
        FlowerLocalizedInfo(
            name: profile.vietnameseName,
            shortDescription: profile.vietnameseDescription,
            facts: [
                profile.vietnameseNote,
                "Các giống khác nhau có thể khác về màu sắc, kích thước, hương thơm hoặc mùa nở.",
                "Trong FlowerDoro, bông hoa này thêm một dáng sưu tầm mới cho khu vườn."
            ]
        )
    }

    private var profile: FlowerProfile {
        Self.profiles[self] ?? FlowerProfile(
            englishName: rawValue.readableFlowerName(),
            vietnameseName: rawValue.readableFlowerName(),
            englishDescription: "A collectible flower for the garden.",
            vietnameseDescription: "Một loài hoa sưu tầm cho khu vườn.",
            englishNote: "This flower brings another color and silhouette to the collection.",
            vietnameseNote: "Bông hoa này thêm màu sắc và dáng vẻ mới cho bộ sưu tập."
        )
    }

    private var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }

    private static let symbolNames = [
        "camera.macro",
        "seal",
        "sun.max",
        "tulip",
        "water.waves",
        "leaf",
        "sparkle",
        "circle.hexagongrid",
        "circle.grid.3x3.circle"
    ]

    private static let profiles: [FlowerKind: FlowerProfile] = [
        .daisy: FlowerProfile(
            englishName: "Daisy",
            vietnameseName: "Cúc họa mi",
            englishDescription: "A bright field flower often linked with fresh starts and simple joy.",
            vietnameseDescription: "Cúc họa mi là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A flower associated with simple white petals and a sunny center.",
            vietnameseNote: "Cúc họa mi giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .rose: FlowerProfile(
            englishName: "Rose",
            vietnameseName: "Hoa hồng",
            englishDescription: "A classic garden bloom known for layered petals, fragrance, and symbolism.",
            vietnameseDescription: "Hoa hồng là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A flower cultivated for centuries in many colors and fragrances.",
            vietnameseNote: "Hoa hồng giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .sunflower: FlowerProfile(
            englishName: "Sunflower",
            vietnameseName: "Hướng dương",
            englishDescription: "A tall, sunny bloom famous for turning its face toward the light.",
            vietnameseDescription: "Hướng dương là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A flower head made from many tiny flowers packed together.",
            vietnameseNote: "Hướng dương giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .tulip: FlowerProfile(
            englishName: "Tulip",
            vietnameseName: "Tulip",
            englishDescription: "A spring bulb flower with smooth cup-shaped petals and bold colors.",
            vietnameseDescription: "Tulip là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A bulb flower strongly associated with spring gardens.",
            vietnameseNote: "Tulip giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .lotus: FlowerProfile(
            englishName: "Lotus",
            vietnameseName: "Hoa sen",
            englishDescription: "A water flower that rises from muddy ponds and opens clean above the surface.",
            vietnameseDescription: "Hoa sen là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An aquatic bloom with leaves that naturally repel water.",
            vietnameseNote: "Hoa sen giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .lavender: FlowerProfile(
            englishName: "Lavender",
            vietnameseName: "Oải hương",
            englishDescription: "A fragrant purple herb-flower often used for calm scents and small bouquets.",
            vietnameseDescription: "Oải hương là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A flower spike loved for its calming scent.",
            vietnameseNote: "Oải hương giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .orchid: FlowerProfile(
            englishName: "Orchid",
            vietnameseName: "Hoa lan",
            englishDescription: "An elegant flower family with sculptural petals and many rare-looking shapes.",
            vietnameseDescription: "Hoa lan là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "One of the largest and most varied flowering plant families.",
            vietnameseNote: "Hoa lan giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .cherryBlossom: FlowerProfile(
            englishName: "Cherry Blossom",
            vietnameseName: "Hoa anh đào",
            englishDescription: "A delicate spring blossom admired for soft pink petals and a short bloom season.",
            vietnameseDescription: "Hoa anh đào là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A spring blossom celebrated for its brief, poetic bloom.",
            vietnameseNote: "Hoa anh đào giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .poppy: FlowerProfile(
            englishName: "Poppy",
            vietnameseName: "Hoa anh túc",
            englishDescription: "A vivid, papery flower with a dark center and a strong wildflower silhouette.",
            vietnameseDescription: "Hoa anh túc là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A flower known for thin petals and open sunny habitats.",
            vietnameseNote: "Hoa anh túc giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .hydrangea: FlowerProfile(
            englishName: "Hydrangea",
            vietnameseName: "Cẩm tú cầu",
            englishDescription: "A round cluster flower whose color can shift with soil conditions.",
            vietnameseDescription: "Cẩm tú cầu là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A clustered bloom that can change color with soil acidity.",
            vietnameseNote: "Cẩm tú cầu giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .peony: FlowerProfile(
            englishName: "Peony",
            vietnameseName: "Mẫu đơn",
            englishDescription: "A lush perennial bloom with many soft petals and a romantic garden presence.",
            vietnameseDescription: "Mẫu đơn là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A long-lived perennial often prized for full, layered blooms.",
            vietnameseNote: "Mẫu đơn giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .camellia: FlowerProfile(
            englishName: "Camellia",
            vietnameseName: "Hoa trà",
            englishDescription: "A glossy-leaved shrub flower with precise petals and a refined look.",
            vietnameseDescription: "Hoa trà là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An evergreen shrub bloom that often flowers in cooler seasons.",
            vietnameseNote: "Hoa trà giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .gardenia: FlowerProfile(
            englishName: "Gardenia",
            vietnameseName: "Dành dành",
            englishDescription: "A creamy white flower famous for a rich, sweet fragrance.",
            vietnameseDescription: "Dành dành là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A fragrant bloom often grown for perfume-like scent.",
            vietnameseNote: "Dành dành giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .jasmine: FlowerProfile(
            englishName: "Jasmine",
            vietnameseName: "Hoa nhài",
            englishDescription: "A small starry flower known for sweet evening fragrance.",
            vietnameseDescription: "Hoa nhài là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A fragrant flower used in teas, perfumes, and garden arches.",
            vietnameseNote: "Hoa nhài giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .magnolia: FlowerProfile(
            englishName: "Magnolia",
            vietnameseName: "Mộc lan",
            englishDescription: "A large elegant blossom that appears on trees and shrubs.",
            vietnameseDescription: "Mộc lan là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An ancient flowering lineage with bold, sculptural blooms.",
            vietnameseNote: "Mộc lan giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .hibiscus: FlowerProfile(
            englishName: "Hibiscus",
            vietnameseName: "Dâm bụt",
            englishDescription: "A tropical-looking flower with broad petals and a showy center.",
            vietnameseDescription: "Dâm bụt là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A warm-climate bloom often associated with vivid colors.",
            vietnameseNote: "Dâm bụt giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .marigold: FlowerProfile(
            englishName: "Marigold",
            vietnameseName: "Cúc vạn thọ",
            englishDescription: "A cheerful gold or orange flower often used in borders.",
            vietnameseDescription: "Cúc vạn thọ là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A hardy garden bloom valued for long-lasting color.",
            vietnameseNote: "Cúc vạn thọ giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .chrysanthemum: FlowerProfile(
            englishName: "Chrysanthemum",
            vietnameseName: "Cúc đại đóa",
            englishDescription: "A many-petaled flower strongly tied to autumn gardens.",
            vietnameseDescription: "Cúc đại đóa là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An autumn bloom with many forms, from pompons to daisies.",
            vietnameseNote: "Cúc đại đóa giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .dahlia: FlowerProfile(
            englishName: "Dahlia",
            vietnameseName: "Thược dược",
            englishDescription: "A bold tuber-grown flower with dramatic geometric petals.",
            vietnameseDescription: "Thược dược là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A tuber flower famous for an enormous range of shapes.",
            vietnameseNote: "Thược dược giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .zinnia: FlowerProfile(
            englishName: "Zinnia",
            vietnameseName: "Cúc zinnia",
            englishDescription: "A bright annual flower that brings strong summer color.",
            vietnameseDescription: "Cúc zinnia là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An easy annual often grown for cutting gardens.",
            vietnameseNote: "Cúc zinnia giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .carnation: FlowerProfile(
            englishName: "Carnation",
            vietnameseName: "Cẩm chướng",
            englishDescription: "A ruffled flower known for spicy fragrance and long vase life.",
            vietnameseDescription: "Cẩm chướng là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A cut flower with fringed petals and many color meanings.",
            vietnameseNote: "Cẩm chướng giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .daffodil: FlowerProfile(
            englishName: "Daffodil",
            vietnameseName: "Thủy tiên vàng",
            englishDescription: "A spring bulb with a trumpet center and bright yellow charm.",
            vietnameseDescription: "Thủy tiên vàng là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A bulb flower often considered a sign of spring.",
            vietnameseNote: "Thủy tiên vàng giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .iris: FlowerProfile(
            englishName: "Iris",
            vietnameseName: "Diên vĩ",
            englishDescription: "A graceful flower with folded petals and sword-like leaves.",
            vietnameseDescription: "Diên vĩ là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A bloom named after the rainbow in Greek tradition.",
            vietnameseNote: "Diên vĩ giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .bluebell: FlowerProfile(
            englishName: "Bluebell",
            vietnameseName: "Chuông xanh",
            englishDescription: "A nodding woodland flower that can carpet shady ground.",
            vietnameseDescription: "Chuông xanh là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A bell-shaped flower often seen in cool woodland scenes.",
            vietnameseNote: "Chuông xanh giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .foxglove: FlowerProfile(
            englishName: "Foxglove",
            vietnameseName: "Mao địa hoàng",
            englishDescription: "A tall spike of tubular bells loved in cottage gardens.",
            vietnameseDescription: "Mao địa hoàng là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A vertical flower spike that attracts pollinators.",
            vietnameseNote: "Mao địa hoàng giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .snapdragon: FlowerProfile(
            englishName: "Snapdragon",
            vietnameseName: "Hoa mõm sói",
            englishDescription: "A playful flower spike with blooms that resemble tiny mouths.",
            vietnameseDescription: "Hoa mõm sói là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A cool-season flower known for stacked, dragon-like blossoms.",
            vietnameseNote: "Hoa mõm sói giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .anemone: FlowerProfile(
            englishName: "Anemone",
            vietnameseName: "Hoa hải quỳ",
            englishDescription: "A delicate bloom with a dark center and windflower charm.",
            vietnameseDescription: "Hoa hải quỳ là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A flower often called windflower in garden traditions.",
            vietnameseNote: "Hoa hải quỳ giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .ranunculus: FlowerProfile(
            englishName: "Ranunculus",
            vietnameseName: "Mao lương",
            englishDescription: "A rose-like bloom made from many thin, silky petals.",
            vietnameseDescription: "Mao lương là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A cut flower prized for dense, layered petals.",
            vietnameseNote: "Mao lương giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .freesia: FlowerProfile(
            englishName: "Freesia",
            vietnameseName: "Lan Nam Phi",
            englishDescription: "A fragrant flower spike with graceful funnel-shaped blooms.",
            vietnameseDescription: "Lan Nam Phi là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A scent-rich bloom often used in bouquets.",
            vietnameseNote: "Lan Nam Phi giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .geranium: FlowerProfile(
            englishName: "Geranium",
            vietnameseName: "Phong lữ",
            englishDescription: "A familiar garden flower grown for clusters of bright blooms.",
            vietnameseDescription: "Phong lữ là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A container favorite with rounded leaves and clustered flowers.",
            vietnameseNote: "Phong lữ giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .begonia: FlowerProfile(
            englishName: "Begonia",
            vietnameseName: "Thu hải đường",
            englishDescription: "A shade-friendly flower with soft petals and decorative leaves.",
            vietnameseDescription: "Thu hải đường là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A garden plant valued for both blooms and foliage.",
            vietnameseNote: "Thu hải đường giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .azalea: FlowerProfile(
            englishName: "Azalea",
            vietnameseName: "Đỗ quyên",
            englishDescription: "A shrub flower that can cover branches in vivid spring color.",
            vietnameseDescription: "Đỗ quyên là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A woodland shrub bloom often grown in acidic soil.",
            vietnameseNote: "Đỗ quyên giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .rhododendron: FlowerProfile(
            englishName: "Rhododendron",
            vietnameseName: "Đỗ quyên lớn",
            englishDescription: "A large shrub bloom with rounded trusses of flowers.",
            vietnameseDescription: "Đỗ quyên lớn là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A mountain and woodland shrub with showy flower clusters.",
            vietnameseNote: "Đỗ quyên lớn giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .wisteria: FlowerProfile(
            englishName: "Wisteria",
            vietnameseName: "Tử đằng",
            englishDescription: "A climbing vine with hanging chains of purple flowers.",
            vietnameseDescription: "Tử đằng là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A woody vine famous for cascading spring racemes.",
            vietnameseNote: "Tử đằng giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .bougainvillea: FlowerProfile(
            englishName: "Bougainvillea",
            vietnameseName: "Hoa giấy",
            englishDescription: "A vivid climbing plant whose color comes from papery bracts.",
            vietnameseDescription: "Hoa giấy là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A warm-climate vine known for papery, bright bracts.",
            vietnameseNote: "Hoa giấy giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .morningGlory: FlowerProfile(
            englishName: "Morning Glory",
            vietnameseName: "Bìm bìm",
            englishDescription: "A twining vine with trumpet flowers that often open early.",
            vietnameseDescription: "Bìm bìm là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A climbing flower known for morning-opening trumpets.",
            vietnameseNote: "Bìm bìm giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .sweetPea: FlowerProfile(
            englishName: "Sweet Pea",
            vietnameseName: "Đậu thơm",
            englishDescription: "A scented climbing flower with soft, fluttery petals.",
            vietnameseDescription: "Đậu thơm là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A fragrant annual vine often grown for bouquets.",
            vietnameseNote: "Đậu thơm giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .pansy: FlowerProfile(
            englishName: "Pansy",
            vietnameseName: "Hoa păng-xê",
            englishDescription: "A small cool-season flower with face-like markings.",
            vietnameseDescription: "Hoa păng-xê là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A compact bloom loved for expressive markings.",
            vietnameseNote: "Hoa păng-xê giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .violet: FlowerProfile(
            englishName: "Violet",
            vietnameseName: "Hoa tím",
            englishDescription: "A small flower with heart-shaped leaves and soft color.",
            vietnameseDescription: "Hoa tím là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A modest bloom often found in cool, shady places.",
            vietnameseNote: "Hoa tím giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .primrose: FlowerProfile(
            englishName: "Primrose",
            vietnameseName: "Anh thảo",
            englishDescription: "An early-season flower that brings color after winter.",
            vietnameseDescription: "Anh thảo là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A low-growing flower often associated with early spring.",
            vietnameseNote: "Anh thảo giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .cosmos: FlowerProfile(
            englishName: "Cosmos",
            vietnameseName: "Sao nhái",
            englishDescription: "A light, airy annual with daisy-like flowers.",
            vietnameseDescription: "Sao nhái là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A summer annual valued for feathery foliage and open blooms.",
            vietnameseNote: "Sao nhái giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .aster: FlowerProfile(
            englishName: "Aster",
            vietnameseName: "Cúc sao",
            englishDescription: "A starry late-season flower loved by pollinators.",
            vietnameseDescription: "Cúc sao là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A daisy-like bloom that often appears late in the season.",
            vietnameseNote: "Cúc sao giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .calendula: FlowerProfile(
            englishName: "Calendula",
            vietnameseName: "Cúc kim tiền",
            englishDescription: "A golden flower also known as pot marigold.",
            vietnameseDescription: "Cúc kim tiền là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A bright edible flower historically used in herbal preparations.",
            vietnameseNote: "Cúc kim tiền giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .gerbera: FlowerProfile(
            englishName: "Gerbera",
            vietnameseName: "Đồng tiền",
            englishDescription: "A bold daisy-like flower with clean, saturated colors.",
            vietnameseDescription: "Đồng tiền là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A popular cut flower with large, simple faces.",
            vietnameseNote: "Đồng tiền giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .lily: FlowerProfile(
            englishName: "Lily",
            vietnameseName: "Hoa ly",
            englishDescription: "A large elegant bloom with strong petals and often rich fragrance.",
            vietnameseDescription: "Hoa ly là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A bulb flower known for dramatic trumpet or star forms.",
            vietnameseNote: "Hoa ly giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .callaLily: FlowerProfile(
            englishName: "Calla Lily",
            vietnameseName: "Hoa rum",
            englishDescription: "A smooth sculptural flower shaped like a rolled cup.",
            vietnameseDescription: "Hoa rum là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A graceful bloom with a single spathe around a central spike.",
            vietnameseNote: "Hoa rum giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .lilyOfTheValley: FlowerProfile(
            englishName: "Lily of the Valley",
            vietnameseName: "Linh lan",
            englishDescription: "A tiny bell flower with a sweet fragrance.",
            vietnameseDescription: "Linh lan là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A woodland flower known for small white bells.",
            vietnameseNote: "Linh lan giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .amaryllis: FlowerProfile(
            englishName: "Amaryllis",
            vietnameseName: "Lan huệ",
            englishDescription: "A large bulb flower often grown indoors for winter color.",
            vietnameseDescription: "Lan huệ là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A bulb bloom with tall stems and dramatic trumpets.",
            vietnameseNote: "Lan huệ giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .clematis: FlowerProfile(
            englishName: "Clematis",
            vietnameseName: "Ông lão",
            englishDescription: "A climbing flower with starry blossoms on vines.",
            vietnameseDescription: "Ông lão là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A flowering vine grown on trellises and fences.",
            vietnameseNote: "Ông lão giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .honeysuckle: FlowerProfile(
            englishName: "Honeysuckle",
            vietnameseName: "Kim ngân",
            englishDescription: "A fragrant tubular flower that grows on shrubs or vines.",
            vietnameseDescription: "Kim ngân là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A nectar-rich bloom often visited by pollinators.",
            vietnameseNote: "Kim ngân giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .fuchsia: FlowerProfile(
            englishName: "Fuchsia",
            vietnameseName: "Lồng đèn",
            englishDescription: "A dangling flower shaped like a tiny lantern.",
            vietnameseDescription: "Lồng đèn là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A hanging bloom with contrasting sepals and petals.",
            vietnameseNote: "Lồng đèn giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .plumeria: FlowerProfile(
            englishName: "Plumeria",
            vietnameseName: "Đại sứ",
            englishDescription: "A tropical flower with waxy petals and sweet fragrance.",
            vietnameseDescription: "Đại sứ là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A warm-climate bloom often used in leis.",
            vietnameseNote: "Đại sứ giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .birdOfParadise: FlowerProfile(
            englishName: "Bird of Paradise",
            vietnameseName: "Thiên điểu",
            englishDescription: "A dramatic tropical flower shaped like a bird in flight.",
            vietnameseDescription: "Thiên điểu là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A sculptural bloom with bold orange and blue forms.",
            vietnameseNote: "Thiên điểu giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .protea: FlowerProfile(
            englishName: "Protea",
            vietnameseName: "Hoa protea",
            englishDescription: "A bold architectural flower with a prehistoric feel.",
            vietnameseDescription: "Hoa protea là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A South African bloom known for sturdy bracts.",
            vietnameseNote: "Hoa protea giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .banksia: FlowerProfile(
            englishName: "Banksia",
            vietnameseName: "Hoa banksia",
            englishDescription: "A cylindrical flower spike with a wild sculptural texture.",
            vietnameseDescription: "Hoa banksia là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An Australian bloom made of many tiny flowers.",
            vietnameseNote: "Hoa banksia giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .waratah: FlowerProfile(
            englishName: "Waratah",
            vietnameseName: "Hoa waratah",
            englishDescription: "A striking red flower head native to Australia.",
            vietnameseDescription: "Hoa waratah là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A bold inflorescence with a strong rounded form.",
            vietnameseNote: "Hoa waratah giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .edelweiss: FlowerProfile(
            englishName: "Edelweiss",
            vietnameseName: "Nhung tuyết",
            englishDescription: "A pale alpine flower with woolly star-shaped bracts.",
            vietnameseDescription: "Nhung tuyết là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An alpine bloom adapted to high mountain conditions.",
            vietnameseNote: "Nhung tuyết giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .yarrow: FlowerProfile(
            englishName: "Yarrow",
            vietnameseName: "Cỏ thi",
            englishDescription: "A flat-topped cluster flower often found in meadows.",
            vietnameseDescription: "Cỏ thi là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A hardy meadow plant with many tiny clustered blooms.",
            vietnameseNote: "Cỏ thi giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .cornflower: FlowerProfile(
            englishName: "Cornflower",
            vietnameseName: "Thanh cúc",
            englishDescription: "A vivid blue wildflower with fringed petals.",
            vietnameseDescription: "Thanh cúc là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A field flower famous for clear blue color.",
            vietnameseNote: "Thanh cúc giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .forgetMeNot: FlowerProfile(
            englishName: "Forget-me-not",
            vietnameseName: "Lưu ly",
            englishDescription: "A tiny blue flower with a sentimental name.",
            vietnameseDescription: "Lưu ly là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A small bloom often linked with remembrance.",
            vietnameseNote: "Lưu ly giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .babyBreath: FlowerProfile(
            englishName: "Baby’s Breath",
            vietnameseName: "Hoa bi",
            englishDescription: "A cloud of tiny white flowers often used in bouquets.",
            vietnameseDescription: "Hoa bi là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A filler flower that creates airy texture.",
            vietnameseNote: "Hoa bi giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .bleedingHeart: FlowerProfile(
            englishName: "Bleeding Heart",
            vietnameseName: "Trái tim rỉ máu",
            englishDescription: "A heart-shaped dangling bloom on arching stems.",
            vietnameseDescription: "Trái tim rỉ máu là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A shade garden flower with distinctive heart forms.",
            vietnameseNote: "Trái tim rỉ máu giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .hollyhock: FlowerProfile(
            englishName: "Hollyhock",
            vietnameseName: "Mãn đình hồng",
            englishDescription: "A tall cottage-garden flower with stacked blooms.",
            vietnameseDescription: "Mãn đình hồng là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A vertical garden flower often grown against walls.",
            vietnameseNote: "Mãn đình hồng giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .delphinium: FlowerProfile(
            englishName: "Delphinium",
            vietnameseName: "Phi yến",
            englishDescription: "A tall spike of blue, purple, or white flowers.",
            vietnameseDescription: "Phi yến là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A dramatic flower spike that adds height to borders.",
            vietnameseNote: "Phi yến giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .lupine: FlowerProfile(
            englishName: "Lupine",
            vietnameseName: "Hoa lupin",
            englishDescription: "A spire of pea-like flowers with bold garden color.",
            vietnameseDescription: "Hoa lupin là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A flower spike from the pea family with palmate leaves.",
            vietnameseNote: "Hoa lupin giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .phlox: FlowerProfile(
            englishName: "Phlox",
            vietnameseName: "Hoa phlox",
            englishDescription: "A clustered flower that can carpet ground or fill borders.",
            vietnameseDescription: "Hoa phlox là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A bloom known for masses of small starry flowers.",
            vietnameseNote: "Hoa phlox giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .verbena: FlowerProfile(
            englishName: "Verbena",
            vietnameseName: "Mã tiên thảo",
            englishDescription: "A small clustered flower that blooms over a long season.",
            vietnameseDescription: "Mã tiên thảo là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A nectar-friendly plant often used in borders and baskets.",
            vietnameseNote: "Mã tiên thảo giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .salvia: FlowerProfile(
            englishName: "Salvia",
            vietnameseName: "Xô thơm hoa",
            englishDescription: "A spike flower loved by bees and hummingbirds.",
            vietnameseDescription: "Xô thơm hoa là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A garden flower with aromatic leaves and tubular blooms.",
            vietnameseNote: "Xô thơm hoa giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .beeBalm: FlowerProfile(
            englishName: "Bee Balm",
            vietnameseName: "Bạc hà ong",
            englishDescription: "A shaggy flower head that attracts pollinators.",
            vietnameseDescription: "Bạc hà ong là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A mint-family bloom with aromatic foliage.",
            vietnameseNote: "Bạc hà ong giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .echinacea: FlowerProfile(
            englishName: "Echinacea",
            vietnameseName: "Cúc tím",
            englishDescription: "A cone-centered daisy often grown in sunny beds.",
            vietnameseDescription: "Cúc tím là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A prairie flower known for a raised central cone.",
            vietnameseNote: "Cúc tím giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .blackEyedSusan: FlowerProfile(
            englishName: "Black-eyed Susan",
            vietnameseName: "Cúc mắt đen",
            englishDescription: "A golden daisy with a dark central cone.",
            vietnameseDescription: "Cúc mắt đen là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A sunny prairie-style flower with a dark eye.",
            vietnameseNote: "Cúc mắt đen giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .hellebore: FlowerProfile(
            englishName: "Hellebore",
            vietnameseName: "Hoa hồng Giáng sinh",
            englishDescription: "A winter or early-spring flower with nodding blooms.",
            vietnameseDescription: "Hoa hồng Giáng sinh là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A shade-tolerant perennial that blooms in cool seasons.",
            vietnameseNote: "Hoa hồng Giáng sinh giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .cyclamen: FlowerProfile(
            englishName: "Cyclamen",
            vietnameseName: "Anh thảo tiên",
            englishDescription: "A swept-back petal flower with patterned leaves.",
            vietnameseDescription: "Anh thảo tiên là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A cool-season flower with reflexed petals.",
            vietnameseNote: "Anh thảo tiên giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .crocus: FlowerProfile(
            englishName: "Crocus",
            vietnameseName: "Nghệ tây cảnh",
            englishDescription: "A small cup flower that often appears very early.",
            vietnameseDescription: "Nghệ tây cảnh là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An early bulb-like bloom that can push through cold soil.",
            vietnameseNote: "Nghệ tây cảnh giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .snowdrop: FlowerProfile(
            englishName: "Snowdrop",
            vietnameseName: "Hoa giọt tuyết",
            englishDescription: "A tiny white nodding flower that signals late winter.",
            vietnameseDescription: "Hoa giọt tuyết là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A cold-season bulb with delicate white bells.",
            vietnameseNote: "Hoa giọt tuyết giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .allium: FlowerProfile(
            englishName: "Allium",
            vietnameseName: "Hoa hành",
            englishDescription: "A spherical flower head made from many tiny star blooms.",
            vietnameseDescription: "Hoa hành là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An ornamental onion with globe-shaped flower heads.",
            vietnameseNote: "Hoa hành giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .gladiolus: FlowerProfile(
            englishName: "Gladiolus",
            vietnameseName: "Lay ơn",
            englishDescription: "A tall sword-leaved flower spike popular in arrangements.",
            vietnameseDescription: "Lay ơn là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A corm flower with blossoms stacked along a stem.",
            vietnameseNote: "Lay ơn giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .canna: FlowerProfile(
            englishName: "Canna",
            vietnameseName: "Hoa dong riềng",
            englishDescription: "A tropical-looking flower with broad leaves.",
            vietnameseDescription: "Hoa dong riềng là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A warm-season plant known for bold foliage and blooms.",
            vietnameseNote: "Hoa dong riềng giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .nasturtium: FlowerProfile(
            englishName: "Nasturtium",
            vietnameseName: "Sen cạn",
            englishDescription: "A bright edible flower with round leaves.",
            vietnameseDescription: "Sen cạn là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A trailing flower often grown in containers and beds.",
            vietnameseNote: "Sen cạn giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .petunia: FlowerProfile(
            englishName: "Petunia",
            vietnameseName: "Dạ yến thảo",
            englishDescription: "A trumpet-shaped flower common in baskets and containers.",
            vietnameseDescription: "Dạ yến thảo là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A long-blooming annual with many colors and patterns.",
            vietnameseNote: "Dạ yến thảo giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .impatiens: FlowerProfile(
            englishName: "Impatiens",
            vietnameseName: "Mai địa thảo",
            englishDescription: "A shade-friendly flower with soft rounded petals.",
            vietnameseDescription: "Mai địa thảo là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A popular bedding plant for shady color.",
            vietnameseNote: "Mai địa thảo giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .lantana: FlowerProfile(
            englishName: "Lantana",
            vietnameseName: "Ngũ sắc",
            englishDescription: "A clustered flower whose colors can shift as blooms age.",
            vietnameseDescription: "Ngũ sắc là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A warm-climate flower cluster loved by butterflies.",
            vietnameseNote: "Ngũ sắc giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .nicotiana: FlowerProfile(
            englishName: "Nicotiana",
            vietnameseName: "Thuốc lá cảnh",
            englishDescription: "A starry tubular flower often fragrant in the evening.",
            vietnameseDescription: "Thuốc lá cảnh là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An ornamental tobacco flower with long tubes.",
            vietnameseNote: "Thuốc lá cảnh giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .stock: FlowerProfile(
            englishName: "Stock",
            vietnameseName: "Hoa mõm chó thơm",
            englishDescription: "A fragrant spike flower used in cool-season bouquets.",
            vietnameseDescription: "Hoa mõm chó thơm là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A cut flower valued for clove-like scent.",
            vietnameseNote: "Hoa mõm chó thơm giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .scabiosa: FlowerProfile(
            englishName: "Scabiosa",
            vietnameseName: "Hoa pincushion",
            englishDescription: "A pincushion-shaped bloom with delicate texture.",
            vietnameseDescription: "Hoa pincushion là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A flower named for its pin-like central details.",
            vietnameseNote: "Hoa pincushion giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .nigella: FlowerProfile(
            englishName: "Nigella",
            vietnameseName: "Tình yêu trong sương",
            englishDescription: "A delicate flower surrounded by fine, misty foliage.",
            vietnameseDescription: "Tình yêu trong sương là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A bloom often called love-in-a-mist.",
            vietnameseNote: "Tình yêu trong sương giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .borage: FlowerProfile(
            englishName: "Borage",
            vietnameseName: "Lưu ly sao",
            englishDescription: "A star-shaped blue flower with edible blossoms.",
            vietnameseDescription: "Lưu ly sao là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A herb flower that attracts bees.",
            vietnameseNote: "Lưu ly sao giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .chamomile: FlowerProfile(
            englishName: "Chamomile",
            vietnameseName: "Cúc La Mã",
            englishDescription: "A small daisy-like flower known for gentle herbal tea.",
            vietnameseDescription: "Cúc La Mã là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "An aromatic bloom often dried for infusions.",
            vietnameseNote: "Cúc La Mã giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .clover: FlowerProfile(
            englishName: "Clover",
            vietnameseName: "Hoa cỏ ba lá",
            englishDescription: "A small rounded flower head common in meadows.",
            vietnameseDescription: "Hoa cỏ ba lá là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A legume flower often visited by bees.",
            vietnameseNote: "Hoa cỏ ba lá giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .heather: FlowerProfile(
            englishName: "Heather",
            vietnameseName: "Thạch thảo bụi",
            englishDescription: "A tiny bell-like flower on low woody shrubs.",
            vietnameseDescription: "Thạch thảo bụi là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A moorland plant known for masses of small blooms.",
            vietnameseNote: "Thạch thảo bụi giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .gorse: FlowerProfile(
            englishName: "Gorse",
            vietnameseName: "Kim tước gai",
            englishDescription: "A bright yellow shrub flower with coconut-like scent.",
            vietnameseDescription: "Kim tước gai là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A spiny shrub with pea-family flowers.",
            vietnameseNote: "Kim tước gai giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .broom: FlowerProfile(
            englishName: "Broom",
            vietnameseName: "Kim tước",
            englishDescription: "A yellow pea-like flower on arching shrub stems.",
            vietnameseDescription: "Kim tước là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A shrub flower that brightens dry sunny places.",
            vietnameseNote: "Kim tước giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .queenAnnesLace: FlowerProfile(
            englishName: "Queen Anne’s Lace",
            vietnameseName: "Hoa ren Nữ hoàng Anne",
            englishDescription: "A lacy white umbel made of many tiny flowers.",
            vietnameseDescription: "Hoa ren Nữ hoàng Anne là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A wildflower with umbrella-like flower clusters.",
            vietnameseNote: "Hoa ren Nữ hoàng Anne giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .tansy: FlowerProfile(
            englishName: "Tansy",
            vietnameseName: "Cúc ngải",
            englishDescription: "A button-like yellow flower in flat clusters.",
            vietnameseDescription: "Cúc ngải là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A hardy herbaceous plant with small golden discs.",
            vietnameseNote: "Cúc ngải giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .goldenrod: FlowerProfile(
            englishName: "Goldenrod",
            vietnameseName: "Cúc vàng hoang",
            englishDescription: "A plume of tiny yellow flowers in late-season meadows.",
            vietnameseDescription: "Cúc vàng hoang là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A pollinator-friendly flower often blooming late.",
            vietnameseNote: "Cúc vàng hoang giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .milkweed: FlowerProfile(
            englishName: "Milkweed",
            vietnameseName: "Bông tai",
            englishDescription: "A cluster flower important to monarch butterflies.",
            vietnameseDescription: "Bông tai là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A plant valued as host habitat for monarch caterpillars.",
            vietnameseNote: "Bông tai giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .passionflower: FlowerProfile(
            englishName: "Passionflower",
            vietnameseName: "Lạc tiên",
            englishDescription: "An intricate vine flower with a crown of filaments.",
            vietnameseDescription: "Lạc tiên là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A complex bloom that looks almost architectural.",
            vietnameseNote: "Lạc tiên giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .hoya: FlowerProfile(
            englishName: "Hoya",
            vietnameseName: "Cẩm cù",
            englishDescription: "A waxy star-shaped flower in rounded clusters.",
            vietnameseDescription: "Cẩm cù là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A houseplant bloom known for porcelain-like flowers.",
            vietnameseNote: "Cẩm cù giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .stephanotis: FlowerProfile(
            englishName: "Stephanotis",
            vietnameseName: "Nhài Madagascar",
            englishDescription: "A waxy white fragrant flower used in wedding bouquets.",
            vietnameseDescription: "Nhài Madagascar là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A vine flower prized for clean white scent.",
            vietnameseNote: "Nhài Madagascar giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        ),
        .tuberose: FlowerProfile(
            englishName: "Tuberose",
            vietnameseName: "Huệ thơm",
            englishDescription: "A white flower spike famous for intense perfume.",
            vietnameseDescription: "Huệ thơm là một loài hoa sưu tầm trong vườn, nổi bật với màu sắc, hương thơm hoặc dáng hoa riêng.",
            englishNote: "A night-fragrant bloom used in perfumery.",
            vietnameseNote: "Huệ thơm giúp khu vườn đa dạng hơn và mang thêm một nét nhận diện mới cho bộ sưu tập."
        )
    ]
}

private struct FlowerProfile {
    let englishName: String
    let vietnameseName: String
    let englishDescription: String
    let vietnameseDescription: String
    let englishNote: String
    let vietnameseNote: String
}

private extension String {
    func kebabCased() -> String {
        unicodeScalars.reduce(into: "") { result, scalar in
            let character = Character(scalar)
            if CharacterSet.uppercaseLetters.contains(scalar) {
                if !result.isEmpty {
                    result.append("-")
                }
                result.append(String(character).lowercased())
            } else {
                result.append(String(character))
            }
        }
    }

    func readableFlowerName() -> String {
        kebabCased()
            .split(separator: "-")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
    }
}

public enum ClockStyle: String, CaseIterable, Codable, Identifiable, Equatable {
    case outline
    case petal
    case gardenBed

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .outline:
            "Outline"
        case .petal:
            "Petal"
        case .gardenBed:
            "Garden Bed"
        }
    }
}

public enum FlowerGrowthStage: String, Codable, Equatable {
    case seed
    case sprout
    case bud
    case bloom

    public static func stage(for progress: Double) -> FlowerGrowthStage {
        switch min(max(progress, 0), 1) {
        case 0..<0.25:
            .seed
        case 0.25..<0.55:
            .sprout
        case 0.55..<0.9:
            .bud
        default:
            .bloom
        }
    }
}

public struct Flower: Codable, Identifiable, Equatable {
    public let id: UUID
    public let kind: FlowerKind
    public let earnedAt: Date
    public let focusMinutes: Int

    public init(id: UUID = UUID(), kind: FlowerKind, earnedAt: Date = Date(), focusMinutes: Int) {
        self.id = id
        self.kind = kind
        self.earnedAt = earnedAt
        self.focusMinutes = focusMinutes
    }
}

public struct UserGarden: Codable, Identifiable, Equatable {
    public let id: UUID
    public var userName: String
    public var flowers: [Flower]

    public init(id: UUID = UUID(), userName: String = "You", flowers: [Flower] = []) {
        self.id = id
        self.userName = userName
        self.flowers = flowers
    }
}
