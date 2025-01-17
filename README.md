Proje Adı: Flutter Blog Uygulaması ve API

Bu proje, Flutter ile geliştirilmiş bir blog uygulaması ve PHP tabanlı bir API’den oluşmaktadır. Kullanıcılar bu uygulamada blog postları oluşturabilir, düzenleyebilir, silebilir, diğer kullanıcıları ve gönderilerini arayabilir ve gönderilere yorum yapabilir.

Uygulama Video Linki:
https://drive.google.com/drive/u/0/folders/1nbdSnnM0TiqRF2-wnUVxun4W1EZaQ5sY

Ekran Görüntüleri:
En alt kısımda


Özellikler:

Kullanıcı kaydı ve giriş işlemleri.
Blog gönderileri oluşturma, listeleme, düzenleme ve silme.
Kullanıcı profili düzenleme.
Kullanıcı arama ve diğer kullanıcıların profillerini görüntüleme.
Gönderilere yorum yapma ve beğenme.
Kullanıcıların gönderileri listelenebilir.

Gereksinimler:

Flutter SDK
PHP 7.x / 8.x
MySQL Veritabanı
XAMPP veya WAMP gibi bir yerel sunucu

Kurulum Adımları:

Projeyi klonlayın.
API dizinindeki config.php dosyasını düzenleyerek MySQL bağlantı bilgilerinizi ekleyin.
Veritabanını kurmak için blogapp.sql dosyasını MySQL’e aktarın.
Flutter projesinde bağımlılıkları yüklemek için flutter pub get komutunu çalıştırın.
API’yi XAMPP/WAMP kullanarak çalıştırın ve uç noktaların doğru çalıştığından emin olun.
Flutter uygulamasını çalıştırmak için flutter run komutunu çalıştırın.

Proje Yapısı:

Flutter kısmında lib klasörü içinde sayfalar ve bileşenler bulunur. API kısmında ise PHP dosyaları yer almaktadır.

Kullanılan Teknolojiler:

Flutter
Dart
PHP
MySQL

API Uç Noktaları:

addComment.php: Gönderilere yorum eklemek için kullanılır.
addPost.php: Yeni bir gönderi eklemek için kullanılır.
checkLike.php: Bir gönderinin beğenilip beğenilmediğini kontrol eder.
get_liked_posts.php: Kullanıcının beğendiği gönderileri getirir.
get_user_posts.php: Bir kullanıcıya ait gönderileri getirir.
get_user.php: Bir kullanıcının profil bilgilerini getirir.
getComments.php: Gönderiye ait yorumları getirir.
getPostDetails.php: Gönderinin detaylarını getirir.
getPosts.php: Tüm gönderileri getirir.
index.php: Test ve başlangıç dosyasıdır.
login.php: Kullanıcı giriş işlemleri için kullanılır.
register.php: Yeni kullanıcı kaydı için kullanılır.
searchPosts.php: Gönderilerde arama yapmak için kullanılır.
searchUsers.php: Kullanıcı aramak için kullanılır.
toggleLike.php: Gönderiyi beğenme veya beğeniyi kaldırma işlemleri için kullanılır.
update_user.php: Kullanıcı profilini güncellemek için kullanılır.
upload_profile_picture.php: Kullanıcının profil fotoğrafını yükler.

Flutter Projesi Dosya Yapısı:
lib/main.dart

Uygulamanın giriş noktasıdır. Sayfa yönlendirmeleri ve uygulama teması burada tanımlanır.
lib/assets/

Statik dosyalar (örneğin, profil için varsayılan görseller) bu klasörde saklanır.
lib/pages/

add_post_page.dart: Kullanıcıların yeni gönderiler oluşturmasını sağlar.
home_page.dart: Uygulamanın ana sayfasıdır. Tüm gönderiler burada listelenir.
login_page.dart: Kullanıcıların giriş yapmasını sağlayan sayfa.
other_user_profile.dart: Diğer kullanıcıların profil bilgilerini ve gönderilerini gösterir.
post_details_page.dart: Bir gönderinin detaylarını ve yorumlarını gösterir.
profile_edit_page.dart: Kullanıcıların profil bilgilerini güncellemesine olanak tanır.
profile_page.dart: Kullanıcı profilinin görüntülendiği sayfa.
register_page.dart: Yeni kullanıcı kaydı sayfası.
search_results_page.dart: Gönderiler arasında arama sonuçlarını listeler.
user_search_page.dart: Kullanıcı arama işlemleri için kullanılan sayfa.

Ekran Görüntüleri:
![11](https://github.com/user-attachments/assets/641a88c9-f2ba-4563-b7bc-00f3294270bc)
![10](https://github.com/user-attachments/assets/ce948522-50dd-49a9-9b04-a0a40a94e203)
![9](https://github.com/user-attachments/assets/94fd134d-93c4-415d-ad9f-d22856ebc408)
![8](https://github.com/user-attachments/assets/3e6fbd97-99b0-42e6-aab0-125a759424c6)
![7](https://github.com/user-attachments/assets/f4e0fd2b-7a93-4452-b57b-edf8071ca0d2)
![6](https://github.com/user-attachments/assets/9c06c053-73ff-47ac-96f7-f2f5050990fa)
![5](https://github.com/user-attachments/assets/e2c5ed31-2ba4-4c88-b3b5-be24352c6bbc)
![4](https://github.com/user-attachments/assets/f92e5c30-746e-40f3-93ec-dde1b4fc589d)
![3](https://github.com/user-attachments/assets/e17ec49e-8349-4a4b-b5fa-a1957e7ef969)
![2](https://github.com/user-attachments/assets/a9a2b556-7d9f-4e51-8592-262d9a394684)
![1](https://github.com/user-attachments/assets/41c8d05d-1683-4179-931f-96dd16cdd44d)
