
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := quick_static
LOCAL_MODULE_FILENAME := libquick

LOCAL_SRC_FILES := $(LOCAL_PATH)/lua_cocos2dx_quick_manual.cpp \
                   $(LOCAL_PATH)/LuaEventNode.cpp \
                   $(LOCAL_PATH)/LuaNodeManager.cpp \
                   $(LOCAL_PATH)/LuaTouchEventManager.cpp \
                   $(LOCAL_PATH)/LuaTouchTargetNode.cpp


LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)

LOCAL_C_INCLUDES := $(LOCAL_EXPORT_C_INCLUDES) \
                    $(LOCAL_PATH)/../../../cocos \
                    $(LOCAL_PATH)/../luajit/include  \
                    $(LOCAL_PATH)/../tolua \
                    $(LOCAL_PATH)/../.. \
                    $(LOCAL_PATH)/../../../cocos/scripting/lua-bindings/manual

LOCAL_CFLAGS := -DCC_LUA_ENGINE_ENABLED=1
LOCAL_EXPORT_CFLAGS := -DCC_LUA_ENGINE_ENABLED=1


include $(BUILD_STATIC_LIBRARY)

