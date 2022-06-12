import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.19 as Kirigami

import headsetkontrol 1.0

import "HeadsetKontrol" as HeadsetKontrol

Kirigami.ScrollablePage {
    id: mainPage
    actions {
        contextualActions: [
            Kirigami.Action {
                id: settingsAction
                icon.name: "settings"
                text: i18nc("@action:button", "Settings")
                onTriggered: root.pageStack.pushDialogLayer(settingsPageComponent, {}, {
                                                                "minimumWidth": Kirigami.Units.gridUnit * 30,
                                                                "minimumHeight": Kirigami.Units.gridUnit * 20,
                                                                "maximumWidth": Kirigami.Units.gridUnit * 50,
                                                                "maximumHeight": Kirigami.Units.gridUnit * 40,
                                                                "width": Kirigami.Units.gridUnit * 40,
                                                                "height": Kirigami.Units.gridUnit * 30
                                                            })
            },
            Kirigami.Action {
                id: quitAction
                icon.name: "gtk-quit"
                text: i18nc("@action:button", "Quit")
                onTriggered: Qt.callLater(Qt.quit())
            }
        ]
    }

    titleDelegate: Kirigami.Heading {
        text: i18n("Headset controls")
        leftPadding: 5
    }

    ColumnLayout {
        spacing: 20

        HeadsetKontrol.GroupBox {
            id: generalInfoBox
            title: i18n("General information")

            RowLayout {
                Kirigami.FormLayout {
                    Layout.preferredWidth: (generalInfoBox.availableWidth) / 2

                    Controls.Label {
                        Kirigami.FormData.label: i18n("Device name") + ":"
                        text: AppController.headsetControl.name !== "" ? AppController.headsetControl.name : i18n("Unavailable")
                    }

                    Controls.Label {
                        Kirigami.FormData.label: i18n("Chat-mix level") + ":"
                        text: AppController.headsetControl.chatMix > -1 ? AppController.headsetControl.chatMix : i18n("Unavailable")
                    }

                    RowLayout {
                        Kirigami.FormData.label: i18n("Battery") + ":"
                        Controls.ProgressBar {
                            implicitWidth: Kirigami.Units.gridUnit * 5
                            from: 0
                            to: 100
                            value: AppController.headsetControl.battery
                            indeterminate: AppController.headsetControl.battery < 0
                        }
                        Controls.Label {
                            text: {
                                if (AppController.headsetControl.battery === -1)
                                    return i18n("Charging");
                                if (AppController.headsetControl.battery === -2)
                                    return i18n("Unavailable");
                                return AppController.headsetControl.battery + "%"
                            }
                        }
                    }
                }

                Kirigami.Separator {
                    Layout.fillHeight: true
                }

                Kirigami.FormLayout {
                    Layout.preferredWidth: (generalInfoBox.availableWidth) / 2

                    Controls.Label {
                        Kirigami.FormData.label: i18n("Capabilities") + ":"
                        text: {
                            var capStr = "";
                            if (AppController.headsetControl.hasSidetoneCapability)
                                capStr += i18n("Sidetone") + "\n";
                            if (AppController.headsetControl.hasBatteryCapability)
                                capStr += i18n("Battery") + "\n";
                            if (AppController.headsetControl.hasNotificationSoundCapability)
                                capStr += i18n("Play notification sound") + "\n";
                            if (AppController.headsetControl.hasLedCapability)
                                capStr += i18n("Set LED mode") + "\n";
                            if (AppController.headsetControl.hasInactiveTimeCapabilities)
                                capStr += i18n("Set inactive time") + "\n";
                            if (AppController.headsetControl.hasChatMixCapabilitiy)
                                capStr += i18n("Chat-Mix") + "\n";
                            if (AppController.headsetControl.hasVoicePromptCapabilitiy)
                                capStr += i18n("Set voice prompt mode") + "\n";
                            if (AppController.headsetControl.hasRotateToMuteCapabilitiy)
                                capStr += i18n("Rotate-To-Mute") + "\n";
                            if (AppController.headsetControl.hasEqualizerPresetCapability)
                                capStr += i18n("Set equalizer preset") + "\n";
                            return capStr.trim();
                        }
                    }
                }
            }
        }

        HeadsetKontrol.GroupBox {
            id: actionBox
            title: i18n("Actions")

            contentItem: Kirigami.FormLayout { // If use a layout, remove it from contentItem
                RowLayout {
                    Kirigami.FormData.label: i18n("Notification sound:")
                    Controls.ComboBox {
                        model: ["Sound 1", "Sound 2"]
                    }
                    Controls.Button {
                        text: i18n("Play")
                    }
                }
            }
        }

        HeadsetKontrol.GroupBox {
            id: settingsBox
            title: i18n("Settings")

            RowLayout{
                Kirigami.FormLayout {
                    Layout.preferredWidth: (settingsBox.availableWidth) / 2

                    Controls.CheckBox {
                        id: rotateToMuteCheckBox
                        text: i18n("Rotate to mute")
                        checked: AppController.config.rotateToMute

                        onClicked: {
                            AppController.config.rotateToMute = rotateToMuteCheckBox.checked;
                            AppController.config.save();
                        }
                    }

                    Controls.CheckBox {
                        id: voicePromptCheckBox
                        text: i18n("Voice prompt")
                        checked: AppController.config.voicePrompt

                        onClicked: {
                            AppController.config.voicePrompt = voicePromptCheckBox.checked;
                            AppController.config.save();
                        }
                    }

                    Controls.CheckBox {
                        id: ledCheckBox
                        text: i18n("LED")
                        checked: AppController.config.led

                        onClicked: {
                            AppController.config.led = ledCheckBox.checked;
                            AppController.config.save();
                        }
                    }
                }

                Kirigami.Separator {
                    Layout.fillHeight:true
                }

                Kirigami.FormLayout {
                    Layout.preferredWidth: (settingsBox.availableWidth) / 2

                    Controls.SpinBox {
                        id: sidetoneSpinBox
                        Kirigami.FormData.label: i18n("Sidetone level") + ":"

                        from: 0
                        to: 128
                        value: AppController.config.sidetone

                        onValueModified: {
                            AppController.config.sidetone = sidetoneSpinBox.value;
                            AppController.config.save();
                        }
                    }

                    Controls.SpinBox {
                        id: inactiveTimeSpinBox
                        Kirigami.FormData.label: i18n("Inactive time") + ":"
                        from: 0
                        to: 90
                        value: AppController.config.inactiveTime
                        textFromValue: function(value, locale) {
                            if (value === 1)
                                return Number(value).toLocaleString(locale, 'f', 0) + " " +i18n("minute");
                            return Number(value).toLocaleString(locale, 'f', 0) + " " + i18n("minutes");
                        }

                        onValueModified: {
                            AppController.config.inactiveTime = inactiveTimeSpinBox.value;
                            AppController.config.save();
                        }
                    }
                }
            }
        }
    }
}
