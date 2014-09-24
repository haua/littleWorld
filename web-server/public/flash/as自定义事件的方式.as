package {

    import flash.events.Event;

    //导入事件类

    public class CustomEvent extends Event {

        //声明自定义事件扩展自事件类成为其子类

        public static  const SENDFLOWER:String="sendFlower";

        //声明静态常量作为事件类型1

        public static  const SENDCAR:String="sendCar";

        //声明静态常量作为事件类型2

        public var info:String;

        //声明变量储存事件信息，这也是我们用自定义事件的主要原因，可以用他来

        //携带额外的信息

        public function CustomEvent(type:String,inf) {

            super(type);

            //调用父类构造函数并设置传入的参数作为事件类型

            info=inf;

            //将传入的参数2存入info

        }

    }

}

//2、男孩类：
package {

    import flash.events.EventDispatcher;

    //导入事件发送者类

    import flash.events.Event;

    //导入事件类

    public class Boy extends EventDispatcher {

        //声明男孩类扩展自事件发送者类，成为其子类

        public function sendFlower() {

            //声明公开送花方法;

            var info:String="玫瑰花";

            //声明局部变量设置发送信息

            var events=new CustomEvent(CustomEvent.SENDFLOWER,info);

            //声明一个新的自定义事件类的实例，并设置类型为第一种、

            //将发送信息存入事件

            this.dispatchEvent(events);

            //发送该事件

        }

        public function sendCar() {

            //声明公开送车方法;

            var info:String="百万跑车";

            //声明局部变量设置发送信息

            var events=new CustomEvent(CustomEvent.SENDCAR,info);

            //声明一个新的自定义事件类的实例，并设置类型为第二种、

            //将发送信息存入事件

            this.dispatchEvent(events);

            //发送该事件

        }

    }

}

//3、女孩类：
package {
    public class Girl {
        public function replay(info):void {
            trace(info);
        }
        //声明公开方法，做出反应
    }
}
//4、文档类：
package {

    import flash.display.Sprite;

    //导入Sprite类

    public class Documents extends Sprite {

        //声明文档类扩展自sprite类

        private var _boy:Boy;

        //声明私有属性为男孩类型

        private var _girl:Girl;

        //声明私有属性为女孩类型

        public function Documents() {

            //构造函数

            _boy=new Boy;

            //创建男孩实例

            _girl=new Girl;

            //创建女孩实例

            _boy.addEventListener(CustomEvent.SENDFLOWER,_hand);

            //为男孩增加类型为CustomEvent.SENDFLOWER的事件监听

            _boy.addEventListener(CustomEvent.SENDCAR,_hand);

            //为男孩增加类型为CustomEvent.SENDCAR的事件监听

            _boy.sendCar();

            //调用男孩的送车的方法。你可以再试着调用男孩的sendFlower

            //方法试试，看结果有什么不同

        }

        private function _hand(E:CustomEvent):void {

            //声明事件处理器

            _girl.replay("我收到一位帅哥送我的："+E.info);

            //调用女孩的replay方法。

        }

    }

}