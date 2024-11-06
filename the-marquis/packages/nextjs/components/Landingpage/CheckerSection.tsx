import Image from "next/image";
import BannerChecker from "@/public/landingpage/BannerChecker.png";
import BannerChecker2 from "@/public/landingpage/BannerChecker2.png";
import DojoLogo from "@/public/landingpage/DojoLogo.png";  

import { Swiper, SwiperSlide } from "swiper/react";
import { Pagination, Autoplay } from "swiper/modules";
import "swiper/css";
import "swiper/css/pagination";
import { useRouter } from "next/navigation"; 
import useGetUserInfo from "~~/utils/api/hooks/useGetUserInfo";

const data = [BannerChecker2, BannerChecker];

export default function CheckerSection() {
  const router = useRouter();
  const { data: userInfo } = useGetUserInfo();

  return (
    <div className="content-fit-center">
      <div className="grid lg:grid-cols-2 grid-cols-1 md:gap-5 gap-0 items-center signup-ludo md:mt-[125px] mt-0 md:px-[72px] md:py-[56px] px-6 py-6">
        <div className="lg:col-span-1 lg:order-1 order-2 col-span-1 relative md:py-[90px] py-0 md:mt-0 mt-[20px]">
          <p className="uppercase landing-title mt-2 lg:mt-0">checkers</p>
          <p
            className="landing-desc md:mt-8 md:mb-14 mt-1 mb-[20px] md:mr-[60px] mr-0"
            style={{
              textTransform: "none",
            }}
          >
            A strategic board game for two players, where they move their pieces across the 
            gameboard to capture the opponent's tokens and reach the opposite side.
          </p>

          <div className="relative w-fit">
            <button
              className="relative z-50 normal-button-think signup-btn text-white flex items-center justify-center space-x-3 border-2 border-[#00ECFFE5] rounded-full py-2 px-4"  // Agregado justify-center para centrar el contenido
              onClick={() => {
                window.location.href = "http://localhost:5173/initgame";
              }}
            >
              <Image
                src={DojoLogo}
                alt="Logo"
                width={200} 
                height={20}
                className="mr-2 left-2px"
              />
            </button>
            <Image
              src={"/landingpage/animation-btn.png"}
              className="decore-btn-signup absolute right-0 md:top-0 top-1 z-10 sm:max-w-[130px] sm:max-h-[100px] max-h-[30px] max-w-[40px]"
              alt="button"
              width={130}
              height={100}
            />
          </div>
          {!userInfo && (
            <div className="md:text-[20px] text-[14px] mt-[17px] font-monserrat">
              Already have an account?
              <span
                className="login-text cursor-pointer"
                style={{ fontWeight: 700 }}
                onClick={() => router.push("/")}
              >
                {" "}
                Login
              </span>
            </div>
          )}

          <div className="custom-swiper-pagination justify-center lg:gap-2 gap-1"></div>
        </div>
        <div className="h-full w-full lg:order-2 order-1 lg:col-span-1 col-span-2 relative lg:pb-0 pb-5">
          <Swiper
            slidesPerView={1}
            spaceBetween={30}
            autoplay={{
              delay: 5000,
              disableOnInteraction: false,
            }}
            modules={[Pagination, Autoplay]}
            pagination={{
              clickable: true,
              el: ".custom-swiper-pagination",
            }}
            className="swiperSignup"
          >
            {data.map((item, index) => (
              <SwiperSlide key={index}>
                <div className="h-full w-full flex flex-col justify-center overflow-hidden rounded-[24px]">
                  {/* Imagen del banner con borde y sombra */}
                  <Image
                    src={item}
                    width={1000}
                    height={400}
                    className="h-full w-full object-cover rounded-[24px] border-[2px] border-[#00ECFFE5] z-20 shadow-xl shadow-[#00ECFFE5]"
                    alt="banner"
                  />
                </div>
              </SwiperSlide>
            ))}
          </Swiper>
        </div>
      </div>
    </div>
  );
}
